require File.join(File.dirname(__FILE__), '..', 'cloudstack.rb')
Puppet::Type.type(:cloudstack_instance).provide(
  'default',
  :parent => Puppet::Provider::CloudStack
) do

 mk_resource_methods

  def self.instances
    # I may need to fail if the server does not have a name?
    connection.servers.collect do |server|
      if (server.state != 'Destroyed') and (server.state != 'Stopping')
      Puppet.debug("Found #{server.display_name} in state: #{server.state}")
        Puppet.debug("Found #{server.display_name} in state: #{server.state}")
        if server.nics.size > 1
          raise(Puppet::Error, "Does not support dual nics (it is just a prototype")
        end
        new(
          :name               => server.display_name,
          :id                 => server.id,
          :flavor             => server.flavor_name,
          :image              => server.image_name,
          :zone               => server.zone_name,
          :network_id         => server.nics.first['networkid'],
          :internal_ipaddress => server.nics.first['ipaddress'],
          :account            => server.account_name,
          :domain             => server.domain_name,
          :host               => server.host_name,
          :state              => server.state.downcase,
          :group              => server.group,
          # for some reason the keypair does not seem to be returned from listvminstnaces
          :keypair            => server.key_pair,
          :ensure             => :present
          # I may want to print network information here
         )
      end
    end.compact
  end

  def create
    unless resource[:flavor] and resource[:zone] and resource[:image]
      raise(Puppet::Error, "Must specify flavor, zone, and image names to create an instance")
    end
    flavor_id  = get_flavor_id(resource[:flavor])
    zone_id    = get_zone_id(resource[:zone])
    image_id   = get_image_id(resource[:image], zone_id)
    network_id = resource[:network] ? get_network_id(resource[:network], zone_id): nil
    Puppet.debug("Bootstrapping instance with:
      :display_name      => #{resource[:name]},
      :image_id          => #{image_id},
      :flavor_id         => #{flavor_id},
      :zone_id           => #{zone_id},
      :network_ids       => #{network_id},
      :keypair           => #{resource[:keypair]},
    ")
    response = connection.servers.bootstrap(
      :display_name      => resource[:name],
      :image_id          => image_id,
      :flavor_id         => flavor_id,
      :zone_id           => zone_id,
      :network_ids       => network_id,
      :key_pair          => resource[:keypair],
      :group             => resource[:group]
    )
    @property_hash[:ensure] = :present
    @property_hash[:internal_ipaddress] = response.nics.first['ipaddress']
  end

  def destroy
   # TODO need to block until delete is completed
    connection.servers.destroy(@property_hash[:id])
    @property_hash[:ensure] = :absent
  end

  def internal_ipaddress
    return @property_hash[:internal_ipaddress] if @property_hash[:internal_ipaddress]

  end

  # perform adhoc state changes
  def state=(state)
     if state == 'running'
       connection.start_virtual_machine(:id => @property_hash[:id])
     elsif state == 'stopped'
       connection.stop_virtual_machine(:id => @property_hash[:id])
     elsif state == 'reboot'
       connection.reboot_virtual_machine(:id => @property_hash[:id])
     end
     @property_hash[:state] = state
  end

  def group
    @property_hash[:group]
  end

  def network
    if nets = connection.list_networks('id' => @property_hash[:network_id])['listnetworksresponse']['network']
      nets.first['name']
    end
  end

  def get_flavor_id(name)
    get_id_from_model(name, 'flavors')
  end

  # this uses the request object and not the connection object...
  def get_image_id(name, zone_id)
    get_id_from_request(name, 'template', 'templatefilter' => 'executable')
  end

  def get_network_id(name, zone_id)
    get_id_from_request(name, 'network', 'zoneid' => zone_id)
  end

  def get_zone_id(name)
    get_id_from_model(name, 'zones')
  end

end
