Puppet::Type.type(:puppet_node).provide(:ssh) do

  desc 'this may be an insane type. it can be used to bootstrap masters and agents using Puppet'

  #commands :example => :example

  #mk_resource_methods

  # self.instances
  # end

  def role
    # ssh into the instance to see if puppet is already installed
    # TODO eventually, this should also check the version
    begin
      results = run_remote_puppet_script('check_puppet_version')
    rescue Puppet::Error => e
      return nil
    end
    version = results['stdout'].split("\n").last.strip
    Puppet.info("Puppet version #{version} is currently installed")
    version
  end

  def role=(role)
    if role == :pe_master
      script_name = 'pe_master'
    elsif role == :pe_agent
      script_name  = 'pe_agent'
    else
      fail("unsupported role #{role.to_s}")
    end
    run_remote_puppet_script(script_name)
  end

  def run_remote_puppet_script(script_name)

    hostname = machinehostname(resource[:machine])
    keyfile  = getprivatekey(resource[:keypair])

    if script_name == 'pe_master'
      answers = 'https://raw.github.com/gist/4229037/d03453ae789797909745b63d44611adc5090c050/gistfile1.txt'
      modulepath = '/etc/puppetlabs/puppet/modules'
    elsif script_name == 'pe_agent'
      answers = 'https://raw.github.com/gist/3299812/9dea06dba93d218c61e5fa9d9e928a265c137239/answers'
    else
      modulepath = '/etc/puppet/modules'
      Puppet.debug("Script name: #{script_name} does not need an answers file")
    end

    Puppet.info("Running script #{script_name} via ssh to '#{hostname}' with key: '#{keyfile}'")

    write_name = "#{hostname}-#{Time.now.to_i}"
    unless File.exists?(script_write_dir)
      Puppet.info('Creating script dir')
      Dir.mkdir(script_write_dir)
    end

    compile_options = {
      'installer_payload' => resource[:installer_payload],
      'answers_payload'   => answers,
      'certname'          => machinehostname(resource[:machine]),
      'puppetmaster'      => machinehostname(resource[:puppetmaster]),
      'facts'             => {'classes' => resource['classes'].to_pson},
      'modulepath'        => modulepath
    }

    Puppet.debug("Compiling script #{script_name} with options:\n#{compile_options.inspect}")

    File.open(File.join(script_write_dir, "#{write_name}.erb"), 'w') do |fh|
      fh.write(
        compile_erb(File.join(script_dir, "#{script_name}.erb"), compile_options)
      )
    end

    require 'puppet/cloudpack'

    Puppet.info("running: ssh root@#{hostname} -i '#{keyfile}'")
    Puppet::CloudPack.install(hostname,
      {
        :install_script => write_name,
        :keyfile        => keyfile,
        :login          => 'root'

      }
    )
  end

  def modules

  end

  def getprivatekey(key)
    fail('Must specify a private key') unless key
    key = key.to_s
    if key =~ /(Cloudstack_keypair\[(\S+)?\])/
      return model.catalog.resource($1).provider.key_file_path
    else
     puts 'It is a path'
      return key
    end
    key
  end

  # if a instance resource was specified, get its internal ip address
  def machinehostname(id)
    # id either tells me how to find the resource or its an ip address of a hostname
    id = id.to_s
    if id =~ /(Cloudstack_instance\[\S+?\])(\[\S+?\])?/
      # if id is a resource
      if res = model.catalog.resource($1)
        if $2
          raise(Puppet::Error, "Do not support things other than internal_ip at the moment")
        else
          # assume we want the internal ip address
          if res.provider.exists?
            res.provider.internal_ipaddress
          else
            fail("Referenced cloudstack instance #{$1} does not exist")
          end
        end
      else
        fail("Puppet resource #{$1} was set at the machine, but not found in the catalog, try hostname instead")
      end
    else
      # otherwise assume id is the hostname of ip address
      return id
    end
  end

  def compile_erb(filename, options)
    ERB.new(File.read(filename)).result(binding)
  end

  def script_write_dir
    File.join(Puppet[:confdir], 'scripts')
  end

  def script_dir
    File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'templates'))
  end

  def find_template(name)
    File.expand_path(File.join(script_dir, "#{name}.erb"))
  end

end
