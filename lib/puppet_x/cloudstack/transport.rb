# class that performs all reusable logic for cloudstack integrations
require 'puppet'

module Puppet_x
  module CloudStack
    require 'fog'
    class Transport

      attr_reader :connection

      def self.transport_path
        File.join(Puppet[:confdir], 'transport.yaml')
      end

      def self.retrieve(catalog=nil)
        if (catalog and transport_resorce = catalog.resource.select {|x| x.type.downcase == 'cloudstack_transport' })
          raise(Puppet::Error, "Found multiple cloudstack transports") if (transport_resource.size > 1)
          options = transport_resource.first.to_hash
        else
          options = YAML.load_file(transport_path)['cloudstack']
        end

        @transport ||= self.new(
          :cloudstack_api_key           => options['api_key'] || raise(Puppet::Error, "must define api_key"),
          :cloudstack_secret_access_key => options['secret_access_key'] || raise(Puppet::Error, "must define secret_access_key"),
          :cloudstack_host              => options['host'] || raise(Puppet::Error, "must define host"),
          :cloudstack_port              => options['port'] || raise(Puppet::Error, "must define port"),
          :cloudstack_path              => options['path'] || raise(Puppet::Error, "must define scheme"),
          :cloudstack_scheme            => options['scheme'] || 'http'
        ).connection
      end

      def initialize(options = {})
        @cloudstack_connection = Fog::Compute.new(options.merge(:provider => 'CloudStack'))
        @connection = @cloudstack_connection
      end

      # logs in
      def login(username, password, domain)
        @cloudstack_instance.login(username, password, domain)
      end

    end
  end
end
