Puppet::Type.type(:puppet_node).provide(:ssh) do

  desc 'this may be an insane type. it can be used to bootstrap masters and agents using Puppet'

  #commands :example => :example

  #mk_resource_methods

  # self.instances
  # end

  def role
    # make an ssh call? decide if the role is already installed?
    false
  end

  def role=(role)
    machinehostname(resource[:machine])
    getprivatekey(resource[:keypair])
    if role == :master
    else
    end
  end

  def modules

  end

  def getprivatekey(key)
    key
  end

  # if a instance resource was specified, get its internal ip address
  def machinehostname(id)
    # id either tells me how to find the resource or its an ip address of a hostname
    id = id.to_s
    if id =~ /(Cloudstack_instance\[\S+?\])(\[\S+?\])?/
      # if id is a resource
      if res = model.catalog.resource($1)
        if $2
          raise(Puppet::Error, "Do not support things other than internal_ip at the moment")
        else
          # assume we want the internal ip address
          res.provider.internal_ipaddress
        end
      else
        raise(Puppet::Error, "Puppet resource #{$1} was set at the machine, but not found in the catalog, try hostname instead")
      end
    else
      # otherwise assume id is the hostname of ip address
      return id
    end
  end

end
