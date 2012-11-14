Puppet::Type.newtype(:cloudstack_network) do

  ensurable

  newparam(:name, :namevar => true) do

  end

  newproperty(:id) do

  end

  newproperty(:cidr) do

  end

  newproperty(:domain) do

  end

end