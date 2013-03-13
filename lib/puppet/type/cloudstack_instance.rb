Puppet::Type.newtype(:cloudstack_instance) do

  ensurable

  newparam(:name, :namevar => true) do

  end

  #newproperty(:flavor_id) do
  #  desc 'This maps to a cloudstack\'s serviceofferingid'
  #end

  #newproperty(:image_id) do
  #  desc 'This maps to cloudstack\'s templateid'
  #end
  #newproperty(:zone_id) do
  #
  #end

  newproperty(:id) do
    desc 'guid for instance'
  end

  #newproperty(:network_id) do
  #  desc 'network instance should be launched in'
  #end

  newproperty(:internal_ipaddress) do
    desc 'internal ip address. Puppet assumes that instances can only have one'
  end

  newproperty(:flavor) do
    desc 'name of flavor'
  end

  newproperty(:image) do
    desc 'name of image'
  end

  newproperty(:zone) do
    desc 'name of zone'
  end

  newproperty(:group) do
    desc 'group of system'
  end

  newproperty(:network) do
    desc 'name of network the instance belongs to'
  end

  newproperty(:account) do
    desc 'account that launched vm'
  end

  newproperty(:domain) do
    desc 'domain of account'
  end

  newproperty(:state) do
    desc 'used to specify states for a vm'
    newvalues(:stopped, :running, :reboot)

    munge do |val|
      val.to_s.downcase
    end
    def insync?(is)
      should = @should.first
      p
      return true if should == is
      return true if should == 'stopped' and is == 'stopping'
      return true if should == 'running' and is == 'starting'
      return false
    end
  end

  newparam(:userdata) do
    desc 'used to set userdata when an instance is created'
  end

  newproperty(:keypair) do
    desc 'keypair to associate with system'
    munge do |value|
      value = value.to_s
      if value =~ /^Cloudstack_keypair\[(\S+)\]/
        $1
      elsif value =~ /^(\S+)\[(\S+)\]/
        fail("#{$1} is not a valid type, expected Cloudstack_keypair")
      else
        value
      end
    end
  end

  autorequire(:cloudstack_keypair) do
    [self[:keypair]]
  end
  # this causes querying the resources to fail ;(
  #validate do
  #  unless self[:zone_id] and self[:template_id] and self[:service_offering_id]
  #    raise(Puppet::Error, "must specify a zone, template, and service offering")
  #  end
  #
  #end

end
