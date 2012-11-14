require File.join(File.dirname(__FILE__), '..', 'cloudstack.rb')
Puppet::Type.type(:cloudstack_flavor).provide(
  :default,
  :parent => Puppet::Provider::CloudStack
) do

  # self.prefetch do
  # end

  mk_resource_methods

  def self.instances

    connection.flavors.collect do |flavor|
      new(
          :name       => flavor.name,
          :id         => flavor.id,
          :cpu_number => flavor.cpu_number,
          :memory     => flavor.memory,
          :ensure => :present
      )
    end
  end

  def id=(id)
    fail_read_only
  end
  def cpu_number=(num)
    fail_read_only
  end
  def memory=(mem)
    fail_read_only
  end

end