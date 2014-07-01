
class Helpers::Process

  def add_facts(facts, host, collection)
    facts.each{|f|
      if f['certname'].eql?(host)
        fact_name = f['name']
        fact_value = f['value']

        if fact_name.include?('processor')
          fact_name = number_to_name(fact_name)
        end

        if fact_name.include?('path')
          fact_value = fact_value.gsub!('"','')
        end

        if collection.instance_of?(Hash)
          if collection[host].nil?
            collection[host] = {}
          end

          collection[host][fact_name] = fact_value

        elsif collection.instance_of?(Array)
          collection << "#{fact_name}=\"#{fact_value}\" "
        else
        end
      end
    }
    return collection
  end

  private
    def number_to_name(name)
      lookup = {
        '1' => 'one', '2' => 'two', '3' => 'three', '4' => 'four', '5' => 'five',
        '6' => 'six', '7' => 'seven', '8' => 'eight', '9' => 'nine', '10' => 'ten',
        '11' => 'eleven', '12' => 'twelve', '13' => 'thirteen', '14' => 'fourteen',
        '15' => 'fifteen', '16' => 'sixteen'
      }

      lookup.each { |k,v|
        if name.include?(k)
          name.gsub!(k,"_#{v}")
        end
      }
      return name
    end

end
