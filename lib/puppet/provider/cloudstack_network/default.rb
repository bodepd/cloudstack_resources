require File.join(File.dirname(__FILE__), '..', 'cloudstack.rb')
Puppet::Type.type(:cloudstack_network).provide(
    :default,
    :parent => Puppet::Provider::CloudStack
) do

  #commands :example => :example

  mk_resource_methods

  def self.instances
    (connection.list_networks['listnetworksresponse']['network'] || []).collect do |net|
      new(
        :name     => net['name'],
        :id       => net['id'],
        :domain   => net['domain'],
        :cidr     => net['cidr'],
        :ensure   => :present
      )
    end
  end

  def create
  end

  def destroy
  end

end