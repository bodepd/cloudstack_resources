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
    newvalues(:agent, :master, :pe_agent, :pe_master, :apply)
    def insync?(is)
      return is =~ /^\d+\.\d+\.\d+/
    end
  end

  newparam(:installer_payload) do
    # right now this is hardcoded to rhel 5 pe installation payload
    defaultto 'https://s3.amazonaws.com/pe-builds/released/2.6.1/puppet-enterprise-2.6.1-el-5-x86_64.tar.gz'
  end

  newparam(:answers_payload) do
    defaultto 'https://raw.github.com/gist/4229037/d03453ae789797909745b63d44611adc5090c050/gistfile1.txt'
  end

  newparam(:puppetmaster) do
    desc 'hostname of puppetmaster to connect to. Used by pe_agent and agent roles.'
  end

  newparam(:facts) do
    desc 'hash of facts that can be used to set instance role'
    defaultto {}
  end

  autorequire(:cloudstack_instance) do
    instances = []
    if self[:machine].to_s =~ /Cloudstack_instance\[(\S+?)\](\[\S+?\])?/
      instances.push($1)
    end
    if self[:puppetmaster].to_s =~ /Cloudstack_instance\[(\S+?)\](\[\S+?\])?/
      instances.push($1)
    end
    instances
  end

end
