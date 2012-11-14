Puppet::Type.newtype(:cloudstack_security_group) do

  ensurable

  newparam(:name, :namevar => true) do

  end

  newproperty(:id) do

  end

  newproperty(:ingress_rules) do

  end

  newproperty(:egress_rules) do

  end

end