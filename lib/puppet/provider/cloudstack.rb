require File.join(
            File.dirname(__FILE__),
            '..',
            '..',
            'puppet_x',
            'cloudstack',
            'transport.rb'
        )

class Puppet::Provider::CloudStack < Puppet::Provider
  # To change this template use File | Settings | File Templates.

  def self.prefetch(resources)
    if self.respond_to?(:instances)
      vms = instances
      resources.keys.each do |name|
        if provider = vms.find{ |pkg| pkg.name == name }
          resources[name].provider = provider
        end
      end
    end
  end

  def self.connection(catalog=nil)
    #require 'ruby-debug';debugger
    # there is no provider at the moment. If there were, it should be fog.
    @transport ||= Puppet_x::CloudStack::Transport.retrieve(catalog)
  end

  def connection
    self.class.connection
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    fail_read_only
  end

  def destroy
    fail_read_only
  end

  def fail_read_only
    raise(Puppet::Error, 'This resource is read only. It does not support being managed')
  end

  # get id from things that have models in fog
  def get_id_from_model(name, type, options={})
    matching = connection.send(type, options).select {|x| x.name == name }
    if matching.size > 1
      raise(Puppet::Error, "Found multiple #{type} matching: #{name}, Puppet expects this to be unique. Failing.")
    elsif matching.empty?
      raise(Puppet::Error, "Did not find a #{type} mathing: ""#{name}"". Failing.")
    else
      matching.first.id
    end
  end

  def get_id_from_request(name, type, options={})
    all_objects = connection.send("list_#{type}s", options)["list#{type}sresponse"][type]
    matching_ids = all_objects.collect do |x|
      if (x['name'] == name)
        x['id']
      else
        nil
      end
    end.compact.uniq
    if matching_ids.size > 1
      raise(Puppet::Error, "Found multiple #{type} matching:\"#{name}\", Puppet expects this to be unique. Failing.")
    elsif matching_ids.empty?
        raise(Puppet::Error, "Did not find a #{type} mathing: \"#{name}\". Failing.")
    else
      matching_ids.first
    end
  end

end
