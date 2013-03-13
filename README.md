## About

## Setting up auth credentials.

your credentials should be stored in a file called transport.yaml in your puppet conf dir.

(for users this is ~/.puppet/, for root, this is /etc/puppet, basically where
puppet.conf lives)

Project that create Puppet resource's for modeling CloudStack objects.

    cloudstack:
      api_key: 'api_key'
      secret_access_key: 'secret_key'
      host: '127.0.0.1'
      port: '8080'
      path: '/client/api'
      scheme: 'http'

## querying for resources, now you can use puppet resource to do all kinds of stuff

#### list zones

    puppet resource cloudstack_zone

#### list flavors

    puppet resource cloudstack_flavor

#### list images

    puppet resource cloudstack_image

#### list networks

    puppet resource cloudstack_network

#### list instances

    puppet resource cloudstack_instance

## managing instances as resources in Puppet's DSL

check the file tests/example.pp, it shows how to create instances as resources,
only resources support being managed at the moment.
