#
# transport object, manages connections to cloudstack API server
#
#cloudstack_transport { 'transport1': }

# this requires advanced zones
#cloudstack_firewall_rule {
#
#}

#cloud_portforward_rule {
#
#}

# this does not

# I need a basic zone to deploy this into

#cloudstack_security_group { 'foo':
#  ensure => present,
#}

#volume {
#
#}

resources { 'cloudstack_instance':
  purge => true
}

# ssh_transport {
#
# }

cloudstack_instance { 'foo1':
  ensure     => present,
  flavor     => 'Small Instance',
  zone       => 'FMT-ACS-001',
  image      => 'CentOS 5.6(64-bit) no GUI (XenServer)',
  network    => 'puppetlabs-network',
  # domain
  # account
  # hostname
}

}


#cloudstack_ssh {
#  classes => {}
#  modules => []
#  ssh_transport =>
#  machine => Cloudstack_instnace['foo1'],
#  type => 'agent'
#}

#
# should I create a domain?
#
