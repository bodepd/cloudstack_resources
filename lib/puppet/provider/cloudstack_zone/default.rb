require File.join(File.dirname(__FILE__), '..', 'cloudstack.rb')
Puppet::Type.type(:cloudstack_zone).provide(
    :default,
    :parent => Puppet::Provider::CloudStack
) do

  # self.prefetch
  # end

  mk_resource_methods

  def self.instances
    conn = connection
    # I could not use the
    conn.zones.collect do |zone|
      new(
          :name         => zone.name,
          :id           => zone.id,
          :network_type => zone.network_type,
          :ensure       => :present
      )
    end
  end

  def id=(id)
    fail_read_only
  end
end