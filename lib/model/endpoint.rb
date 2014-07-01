require File.expand_path('../../helpers/process', __FILE__)

class EndPoint

  attr_accessor :cache_timeout
  THREAD_COUNT = 40

  def initialize(puppetdb_helper)
    @db_helper = puppetdb_helper
    @cache_timeout = 1800
  end

  def reload(type)
    nodes = @db_helper.get_nodes

    @rundeck_data = Hash.new

    helper = Helpers::Process.new

    mutex = Mutex.new

    per_type_cache = "/tmp/puppetdb-resource.#{type}"

    THREAD_COUNT.times.map {
      Thread.new(nodes, @rundeck_data) do |nodes|
        while node = mutex.synchronize { nodes.pop }
          host = node['name']
          facts = @db_helper.get_facts(host)
          if !facts.nil?
            mutex.synchronize { helper.add_facts(facts, host, @rundeck_data) }
          end
        end
      end
    }.each(&:join)

    data = case type
      when 'json' then to_json(false)
      when 'yaml' then to_yaml(false)
      when 'xml' then to_xml(false)
      else "unknown"
    end

    File.open(per_type_cache, 'w') { |file| file.write(data) }

    return data
  end

  def to_json(parse_data=true)
    parse('json') if parse_data == true
    if @rundeck_data.is_a?(String)
      @rundeck_data
    else
      @rundeck_data.to_json
    end
  end

  def to_yaml(parse_data=true)
    parse('yaml') if parse_data == true
    if @rundeck_data.is_a?(String)
      @rundeck_data
    else
      @rundeck_data.to_yaml
    end
  end

  def to_xml(parse_data=true)
    helper = Helpers::Process.new

    parse('xml') if parse_data == true
    if @rundeck_data.is_a?(String)
      @rundeck_data
    else
      data = Array.new
      data << "<project>\n"
      @rundeck_data.keys.each {|n|
        data << "<node name=\"#{n}\""
        @rundeck_data[n].each {|k,v|
          data << "#{k}=\"#{v}\""
        }
        data << "/>\n"
      }
      data << "</project>"
      xml = data.join(" ")

      @rundeck_data = xml
    end
  end


  def parse(type)
    per_type_cache = "/tmp/puppetdb-resource.#{type}"

    if File.exist?(per_type_cache)
      file = File.new(per_type_cache)
      t_now = Time.at(Time.now.to_i)
      t_file = Time.at(file.mtime.to_i)

      if t_now < (t_file + @cache_timeout)
        p "reading from cache for #{type}"
        @rundeck_data = File.new(per_type_cache, 'r').read
      else
        p "not reading from cache for: #{type}"
        reload(type)
      end
    else
      p "not reading from cache for: #{type}"
      reload(type)
    end
  end

  def clear_cache
    cache_files = ['/tmp/puppetdb-resource.xml','/tmp/puppetdb-resource.json','/tmp/puppetdb-resource.yaml']

    cache_files.each do |file|
      if File.exist?(file)
        FileUtils.rm file
      end
    end
    "Cached cleared"
  end

end
