Puppet::Type.newtype(:cloudstack_zone) do

  ensurable

  newparam(:name, :namevar => true) do

  end

  newproperty(:id) do
    desc 'unique id of the zone'
  end

  newproperty(:network_type) do
    desc 'type of network'
  end

end