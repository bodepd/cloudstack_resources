Puppet::Type.newtype(:puppet_node) do

  desc 'type that is used to orchestrate puppet runs'

  newparam(:name, :namevar => true) do
    desc 'name'
  end

  newparam(:classes) do
    desc 'classes to apply to the node. Only makes sense for an agent'
  end

  newparam(:machine) do
    desc 'machine where puppet actions are performed. Takes a reference or a hostname/ipaddress'
  end

  newproperty(:modules) do
    desc 'modules to install from the forge (only makes sense for a master role'
  end

  newparam(:keypair) do
    desc 'keypair to use to connect'
  end

  newproperty(:role) do
    desc 'role of this puppet instance'
    newvalues(:agent, :master)
  end

  autorequire(:cloudstack_instance) do
    if self[:machine].to_s =~ /Cloudstack_instance\[(\S+?)\](\[\S+?\])?/
      [$1]
    end
  end

end
