
class Helpers::Process

  def add_facts(facts, host)

    fact_collection = { host => {} }
    facts.each{|f|
      if f['certname'].eql?(host)
        fact_name = f['name']
        fact_value = f['value']

        if fact_name.include?('hostname')
          fact_value = host
        end

        if !is_excluded?(fact_name)
          fact_collection[host][fact_name] = fact_value
        end

      end
    }
    return fact_collection
  end

  def is_excluded?(fact)

    excluded_facts = [
      '^processor(s|\d+)$', '^path$', '^utc_offset$', '^os$',
      '^ec2_metrics_vhostmd$', '^ec2_network_interfaces_macs.*',
      '^ec2_userdata$', '^ec2_metadata$',
      '^partitions$', '^system_uptime$', '^apt_package_updates$',
      '^ec2_public_keys_.*', '^sshfp_.*', '^ssh.*key$', '^.*serialnumber$'
    ]

    match = false
    for ex in excluded_facts
      if fact.match(ex)
        match = true
        break;
      end
    end

    return match
  end

end
