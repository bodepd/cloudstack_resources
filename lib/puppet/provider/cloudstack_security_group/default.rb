require File.join(File.dirname(__FILE__), '..', 'cloudstack.rb')
Puppet::Type.type(:cloudstack_security_group).provide(
    :default,
    :parent => Puppet::Provider::CloudStack
) do

  #commands :example => :example

  mk_resource_methods

  def self.instances
    # I may need to fail if the server does not have a name?
    connection.security_groups.collect do |sg|
      new(
        :name          => sg.name,
        :id            => sg.id,
        :ingress_rules => sg.ingress_rules,
        :egress_rules  => sg.egress_rules,
        :ensure        => :present
        # I may want to print network information here
      )
    end
  end

  def create
    require 'ruby-debug';debugger
    connection.security_groups.create(
      :name      => resource[:name]
    )
  end

  def destroy
    # TODO need to block until delete is completed
    connection.servers.destroy(@property_hash[:id])
  end

  def id=(id)
    fail_read_only
  end

end