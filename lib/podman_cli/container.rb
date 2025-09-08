module PodmanCli
  # Container management interface
  class Container
    def initialize(client)
      @client = client
    end

    # List all containers
    #
    # @param all [Boolean] Show all containers (default: false, only running)
    # @param filters [Hash] Filters to apply (e.g., { status: 'running' })
    # @return [Array<Hash>] Array of container information
    def list(all: false, filters: {})
      args = ['ps']
      args << '--all' if all
      
      filters.each do |key, value|
        args << '--filter' << "#{key}=#{value}"
      end

      @client.execute_json(args)
    end

    # Get detailed information about a container
    #
    # @param name_or_id [String] Container name or ID
    # @return [Hash] Container information
    # @raise [ContainerNotFoundError] If container is not found
    def inspect(name_or_id)
      result = @client.execute_json(['inspect', name_or_id])
      result.first
    rescue CommandError => e
      if e.stderr&.include?('no such container')
        raise ContainerNotFoundError.new("Container not found: #{name_or_id}")
      end
      raise
    end

    # Create a new container
    #
    # @param image [String] Image name or ID
    # @param name [String, nil] Container name
    # @param command [String, Array, nil] Command to run
    # @param options [Hash] Additional options
    # @return [String] Container ID
    def create(image, name: nil, command: nil, **options)
      args = ['create']
      
      args.concat(['--name', name]) if name
      
      # Handle common options
      args.concat(['--detach']) if options[:detach]
      args.concat(['--interactive']) if options[:interactive]
      args.concat(['--tty']) if options[:tty]
      args.concat(['--rm']) if options[:rm]
      
      # Handle port mappings
      if options[:ports]
        options[:ports].each do |port_mapping|
          args.concat(['--publish', port_mapping])
        end
      end
      
      # Handle volume mounts
      if options[:volumes]
        options[:volumes].each do |volume_mapping|
          args.concat(['--volume', volume_mapping])
        end
      end
      
      # Handle environment variables
      if options[:env]
        options[:env].each do |key, value|
          args.concat(['--env', "#{key}=#{value}"])
        end
      end
      
      args << image
      
      if command
        if command.is_a?(Array)
          args.concat(command)
        else
          args << command
        end
      end
      
      @client.execute(args).strip
    end

    # Start a container
    #
    # @param name_or_id [String] Container name or ID
    # @return [String] Container ID
    def start(name_or_id)
      @client.execute(['start', name_or_id]).strip
    end

    # Stop a container
    #
    # @param name_or_id [String] Container name or ID
    # @param timeout [Integer, nil] Timeout in seconds
    # @return [String] Container ID
    def stop(name_or_id, timeout: nil)
      args = ['stop']
      args.concat(['--time', timeout.to_s]) if timeout
      args << name_or_id
      
      @client.execute(args).strip
    end

    # Restart a container
    #
    # @param name_or_id [String] Container name or ID
    # @param timeout [Integer, nil] Timeout in seconds
    # @return [String] Container ID
    def restart(name_or_id, timeout: nil)
      args = ['restart']
      args.concat(['--time', timeout.to_s]) if timeout
      args << name_or_id
      
      @client.execute(args).strip
    end

    # Remove a container
    #
    # @param name_or_id [String] Container name or ID
    # @param force [Boolean] Force removal of running container
    # @param volumes [Boolean] Remove associated volumes
    # @return [String] Container ID
    def remove(name_or_id, force: false, volumes: false)
      args = ['rm']
      args << '--force' if force
      args << '--volumes' if volumes
      args << name_or_id
      
      @client.execute(args).strip
    end

    # Execute a command in a running container
    #
    # @param name_or_id [String] Container name or ID
    # @param command [String, Array] Command to execute
    # @param interactive [Boolean] Keep STDIN open
    # @param tty [Boolean] Allocate a pseudo-TTY
    # @return [String] Command output
    def exec(name_or_id, command, interactive: false, tty: false)
      args = ['exec']
      args << '--interactive' if interactive
      args << '--tty' if tty
      args << name_or_id
      
      if command.is_a?(Array)
        args.concat(command)
      else
        args << command
      end
      
      @client.execute(args)
    end

    # Get container logs
    #
    # @param name_or_id [String] Container name or ID
    # @param follow [Boolean] Follow log output
    # @param tail [Integer, nil] Number of lines to show from the end
    # @param timestamps [Boolean] Show timestamps
    # @return [String] Log output
    def logs(name_or_id, follow: false, tail: nil, timestamps: false)
      args = ['logs']
      args << '--follow' if follow
      args.concat(['--tail', tail.to_s]) if tail
      args << '--timestamps' if timestamps
      args << name_or_id
      
      @client.execute(args)
    end

    # Run a new container (create + start)
    #
    # @param image [String] Image name or ID
    # @param command [String, Array, nil] Command to run
    # @param options [Hash] Additional options
    # @return [String] Container output (if not detached)
    def run(image, command: nil, **options)
      args = ['run']
      
      # Handle common options
      args.concat(['--detach']) if options[:detach]
      args.concat(['--interactive']) if options[:interactive]
      args.concat(['--tty']) if options[:tty]
      args.concat(['--rm']) if options[:rm]
      args.concat(['--name', options[:name]]) if options[:name]
      
      # Handle port mappings
      if options[:ports]
        options[:ports].each do |port_mapping|
          args.concat(['--publish', port_mapping])
        end
      end
      
      # Handle volume mounts
      if options[:volumes]
        options[:volumes].each do |volume_mapping|
          args.concat(['--volume', volume_mapping])
        end
      end
      
      # Handle environment variables
      if options[:env]
        options[:env].each do |key, value|
          args.concat(['--env', "#{key}=#{value}"])
        end
      end
      
      args << image
      
      if command
        if command.is_a?(Array)
          args.concat(command)
        else
          args << command
        end
      end
      
      @client.execute(args)
    end
  end
end

