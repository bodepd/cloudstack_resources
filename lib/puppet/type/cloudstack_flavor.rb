Puppet::Type.newtype(:cloudstack_flavor) do

  ensurable

  newparam(:name, :namevar => true) do

  end

  newproperty(:id) do
    desc 'unique id for flavor, this is a read only property'
  end

  newproperty(:cpu_number) do
    desc 'number of cpus to be allocated for a flavor type'
  end

  newproperty(:memory) do
    desc 'amount of memory allocated to instance of this flavor type'
  end

  # things that may need to become properties
  #cpu_speed=500,
  #created="2012-10-23T04:07:46-0700",
  #default_use=false,
  #display_text=nil,
  #domain=nil,
  #host_tags=nil,
  #is_system=nil,
  #limit_cpu_use=false,
  #tags=nil,
  #system_vm_type=nil,
  #storage_type="shared",
  #offer_ha=false,
  #network_rate=nil,

end