Puppet::Type.newtype(:cloudstack_image) do

  ensurable

  newparam(:name, :namevar => true) do

  end

  newproperty(:id) do
    desc 'unique id for template, this is a read only property'
  end

end