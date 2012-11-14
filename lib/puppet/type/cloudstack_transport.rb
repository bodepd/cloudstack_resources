require 'puppet'
Puppet::Type.newtype(:cloudstack_transport) do
  @doc = "Manage transport connectivity info such as username, password, server."

  newparam(:name, :namevar => true) do
    desc "The name of the network transport."
  end

  newparam(:username) do
  end

  newparam(:password) do
  end

  newparam(:host) do

  end

  newparam(:path) do

  end

  newparam(:port) do

  end

  newparam(:scheme) do

  end

  newparam(:api_key) do

  end

  newparam(:secret_key) do

  end
end

Puppet::Type.newmetaparam(:transport) do
  desc "Provide a new metaparameter for all resources called transport."
end
