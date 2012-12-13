if (($::ensure != 'present') and ($::ensure != 'absent')) {
  fail('invalid ensure value')
}

resources { 'cloudstack_instance':
  purge => true
}

Cloudstack_instance {
  image      => 'CentOS 5.6 key + pw',
  flavor     => 'Large Local',
  zone       => 'ACS-FMT-1',
  #zone       => 'FMT-ACS-001',
  network    => 'puppetlabs-network',
  keypair    => 'dans_keypair4',
  require    => Cloudstack_keypair['dans_keypair4'],
}

cloudstack_keypair { 'dans_keypair4':
  ensure    => $::ensure,
  cache_key => true,
}

cloudstack_instance { 'foo3':
  ensure     => $::ensure,
  group      => 'role=puppetmaster',
}

cloudstack_instance { 'foo4':
  ensure     => $::ensure,
  group      => 'role=db',
}

cloudstack_instance { 'foo5':
  ensure   => $::ensure,
  userdata => 'foo',
}

if $::ensure != 'absent' {
  puppet_node { 'puppet_master':
    role    => 'pe_master',
    machine => "Cloudstack_instance[foo3]",
    keypair => Cloudstack_keypair['dans_keypair4'],
    require => Cloudstack_keypair['dans_keypair4'],
    #machine => Cloudstack_instance['foo1'],
  }

  puppet_node { 'puppet_agent1':
    role         => 'pe_agent',
    machine      => "Cloudstack_instance[foo4]",
    keypair      => Cloudstack_keypair['dans_keypair4'],
    require      => [Cloudstack_keypair['dans_keypair4'], Puppet_node['puppet_master']],
    puppetmaster => "Cloudstack_instance[foo3]",
    classes      => {'apache' => {}}
  }

  puppet_node { 'puppet_agent2':
    role         => 'pe_agent',
    machine      => "Cloudstack_instance[foo5]",
    keypair      => Cloudstack_keypair['dans_keypair4'],
    require      => [Cloudstack_keypair['dans_keypair4'], Puppet_node['puppet_master']],
    puppetmaster => "Cloudstack_instance[foo3]",
    classes      => {'apache' => {}}
  }
}
