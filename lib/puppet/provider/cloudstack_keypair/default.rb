require File.join(File.dirname(__FILE__), '..', 'cloudstack.rb')
Puppet::Type.type(:cloudstack_keypair).provide(
    'default',
    :parent => Puppet::Provider::CloudStack
) do

  mk_resource_methods

  def self.instances
    # I may need to fail if the server does not have a name?
    connection.list_ssh_key_pairs['listsshkeypairsresponse']['sshkeypair'].collect do |keypair|
      #require 'ruby-debug';debugger
      new(
        :name        => keypair['name'],
        :fingerprint => keypair['fingerprint'],
        :ensure => :present
      )
    end
  end

  def create
    #domain_id  = get_domain_id(resource[:domain])
    #project_id    = get_project_id(resource[:project])
    Puppet.debug("Bootstrapping instance with:
      #{resource[:name]}
    ")

    response = connection.create_ssh_key_pair(
      resource[:name]
    )['createsshkeypairresponse']['keypair']
    # if the resource is locally caching created keys
    if resource['cache_key']
      if resource['key_file']
        key_file = resource[:key_file]
      else
        key_file = key_file_path(response['fingerprint'])
      end
      FileUtils.mkdir_p(File.dirname(key_file))
      if File.exists?(key_file)
        fail("keyfile: #{key_file} already exists, not going to override")
      end
      Puppet.info("Writing your private key to #{key_file}")
      File.new(key_file, 'w').write(response['privatekey'])
      File.chmod(0600, key_file)
    end
    @property_hash[:fingerprint] = response['fingerprint']
    @property_hash[:privatekey]  = response['privatekey']
    @property_hash[:ensure]      = :present
  end

  def destroy
    connection.delete_ssh_key_pair(resource[:name])
  end

  def privatekey
    if fingerprint
      File.read(key_file_path(fingerprint))
    else
      fail('Expected fingerprint to be set')
    end
  end

  def fingerprint
    @property_hash[:fingerprint]
  end

  def key_file_path(fingerprint_arg=fingerprint)
    File.join(Puppet[:confdir], 'cloudstack', 'keypair', fingerprint_arg, 'id_rsa')
  end

  def flush
    @property_hash = resource.to_hash
  end

end