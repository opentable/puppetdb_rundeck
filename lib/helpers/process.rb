
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
          fact_collection[host][fact_name] = encode_fact(fact_value)
        end

      end
    }
    return fact_collection
  end

  def encode_fact(fact)
    encoded = fact.gsub(/\n/,'&#10;')
    encoded.gsub!(/\s/,'&#032;')
    encoded.gsub!(/\t/,'&#009;')
    encoded.gsub!(/\"/,'&quot;')
    return encoded
  end

  def is_excluded?(fact)

    excluded_facts = [
      '^processor(s|\d+)$', '^path$', '^utc_offset$', '^os$',
      '^ec2_metrics_vhostmd$', '^ec2_network_interfaces_macs.*',
      '^ec2_userdata$', '^ec2_metadata$',
      '^partitions$', '^system_uptime$', '^apt_package_updates$',
      '^.*serialnumber$', '^ssh.*key$', '^sshfp_.*', 
      '^ec2_public_keys_.*', '^ecs_iam_info_.*',
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
