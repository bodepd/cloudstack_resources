Puppet::Type.newtype(:cloudstack_keypair) do

  ensurable

  newparam(:name, :namevar => true) do

  end

  newproperty(:account) do

  end

  newproperty(:domain) do

  end

  newproperty(:project) do

  end

  newproperty(:privatekey) do
  end

  newproperty(:fingerprint) do

  end

  newparam(:cache_key) do
    desc 'whether the private key should be cached'
  end

  newparam(:key_file) do
    desc 'file path where key should be stored'
  end
end