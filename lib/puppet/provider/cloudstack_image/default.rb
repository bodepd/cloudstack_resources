require File.join(File.dirname(__FILE__), '..', 'cloudstack.rb')
Puppet::Type.type(:cloudstack_image).provide(
  :default,
  :parent => Puppet::Provider::CloudStack
) do

  # self.prefetch
  # end

  mk_resource_methods

  def self.instances
    conn = connection
    # I could not use the
    conn.list_templates('templatefilter' => 'executable')['listtemplatesresponse']['template'].collect do |image|
      new(
          :name       => image['name'],
          :id         => image['id'],
          :ensure => :present
      )
    end
  end

  def id=(id)
    fail_read_only
  end

end