require File.expand_path('../../helpers/process', __FILE__)
require 'thread'
require 'thwait'

class EndPoint

  attr_accessor :cache_timeout
  attr_accessor :thread_count

  def initialize(puppetdb_helper, cache_timeout, thread_count, short_nodenames)
    @db_helper = puppetdb_helper
    @cache_timeout = cache_timeout
    @thread_count = thread_count
    @short_nodenames = short_nodenames
  end

  def reload(type)
    p "reloading data"
    if @nodes.nil? or @nodes.empty?
      @nodes = @db_helper.get_nodes
    end

    @rundeck_data = Hash.new

    helper = Helpers::Process.new

    mutex = Mutex.new

    per_type_cache = "/tmp/puppetdb-resource.#{type}"

    data_elements = []
    process_threads = []

    @thread_count.times.map {
      t = Thread.new(@nodes) do |nodes|
        while node = mutex.synchronize { @nodes.pop }
          host = node['name']
          facts = @db_helper.get_facts(host)
          
          if !facts.nil?
            host_data = helper.add_facts(facts, host)
            tags = @db_helper.get_tags(host)

            if !tags.nil?
              host_data[host]['tags'] = tags.join(',') 
            end

            if @short_nodenames && host.include?('.')
              puts 'doing it...'
              shortname = host.split('.')[0]
              host_data[shortname] = host_data[host]
              host_data.delete(host)
            end

            mutex.synchronize do
              data_elements.push(host_data)
            end
          end
        end
      end
      process_threads.push(t)
    }

    ThreadsWait.all_waits(*process_threads)

    data_elements.each do |item|
      #sleep(Random.new.rand(1..10))
      @rundeck_data.merge!(item) if @rundeck_data.is_a?(Hash)
    end

    data = case type
      when 'json' then self.to_json(false)
      when 'yaml' then self.to_yaml(false)
      when 'xml' then to_xml(false)
      else 'unknown'
    end

    File.open(per_type_cache, 'w') { |file| file.write(data) }

    return data
  end

  def to_json(parse_data)
    p "parse_data is: #{parse_data}"
    parse('json') if parse_data == true
    if @rundeck_data.is_a?(String)
      @rundeck_data
    else
      @rundeck_data.to_json
    end
  end

  def to_yaml(parse_data)
    p "parse_data is: #{parse_data}"
    parse('yaml') if parse_data == true
    if @rundeck_data.is_a?(String)
      @rundeck_data
    else
      @rundeck_data.to_yaml
    end
  end

  def to_xml(parse_data=true)
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
    cache_files = ['/tmp/puppetdb-resource.json','/tmp/puppetdb-resource.yaml']

    cache_files.each do |file|
      if File.exist?(file)
        FileUtils.rm file
      end
    end
    "Cached cleared"
  end

end
