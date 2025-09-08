module PodmanCli
  # Pod management interface
  class Pod
    def initialize(client)
      @client = client
    end

    # List all pods
    #
    # @param filters [Hash] Filters to apply (e.g., { status: 'running' })
    # @return [Array<Hash>] Array of pod information
    def list(filters: {})
      args = ['pod', 'ps']
      
      filters.each do |key, value|
        args << '--filter' << "#{key}=#{value}"
      end

      @client.execute_json(args)
    end

    # Get detailed information about a pod
    #
    # @param name_or_id [String] Pod name or ID
    # @return [Hash] Pod information
    # @raise [PodNotFoundError] If pod is not found
    def inspect(name_or_id)
      result = @client.execute_json(['pod', 'inspect', name_or_id])
      result.first
    rescue CommandError => e
      if e.stderr&.include?('no such pod')
        raise PodNotFoundError.new("Pod not found: #{name_or_id}")
      end
      raise
    end

    # Create a new pod
    #
    # @param name [String, nil] Pod name
    # @param ports [Array<String>, nil] Port mappings
    # @param labels [Hash] Labels to apply to the pod
    # @param share [String, nil] Comma-separated list of namespaces to share
    # @return [String] Pod ID
    def create(name: nil, ports: nil, labels: {}, share: nil)
      args = ['pod', 'create']
      
      args.concat(['--name', name]) if name
      args.concat(['--share', share]) if share
      
      # Handle port mappings
      if ports
        ports.each do |port_mapping|
          args.concat(['--publish', port_mapping])
        end
      end
      
      # Handle labels
      labels.each do |key, value|
        args.concat(['--label', "#{key}=#{value}"])
      end
      
      @client.execute(args).strip
    end

    # Start a pod
    #
    # @param name_or_id [String] Pod name or ID
    # @return [String] Pod ID
    def start(name_or_id)
      @client.execute(['pod', 'start', name_or_id]).strip
    end

    # Stop a pod
    #
    # @param name_or_id [String] Pod name or ID
    # @param timeout [Integer, nil] Timeout in seconds
    # @return [String] Pod ID
    def stop(name_or_id, timeout: nil)
      args = ['pod', 'stop']
      args.concat(['--time', timeout.to_s]) if timeout
      args << name_or_id
      
      @client.execute(args).strip
    end

    # Restart a pod
    #
    # @param name_or_id [String] Pod name or ID
    # @return [String] Pod ID
    def restart(name_or_id)
      @client.execute(['pod', 'restart', name_or_id]).strip
    end

    # Pause a pod
    #
    # @param name_or_id [String] Pod name or ID
    # @return [String] Pod ID
    def pause(name_or_id)
      @client.execute(['pod', 'pause', name_or_id]).strip
    end

    # Unpause a pod
    #
    # @param name_or_id [String] Pod name or ID
    # @return [String] Pod ID
    def unpause(name_or_id)
      @client.execute(['pod', 'unpause', name_or_id]).strip
    end

    # Remove a pod
    #
    # @param name_or_id [String] Pod name or ID
    # @param force [Boolean] Force removal of running pod
    # @return [String] Pod ID
    def remove(name_or_id, force: false)
      args = ['pod', 'rm']
      args << '--force' if force
      args << name_or_id
      
      @client.execute(args).strip
    end

    # Kill a pod
    #
    # @param name_or_id [String] Pod name or ID
    # @param signal [String, nil] Signal to send (default: SIGKILL)
    # @return [String] Pod ID
    def kill(name_or_id, signal: nil)
      args = ['pod', 'kill']
      args.concat(['--signal', signal]) if signal
      args << name_or_id
      
      @client.execute(args).strip
    end

    # Get pod statistics
    #
    # @param name_or_id [String, nil] Pod name or ID (nil for all pods)
    # @param no_stream [Boolean] Don't stream stats, just print once
    # @return [String] Statistics output
    def stats(name_or_id = nil, no_stream: true)
      args = ['pod', 'stats']
      args << '--no-stream' if no_stream
      args << name_or_id if name_or_id
      
      @client.execute(args)
    end

    # Get pod top (running processes)
    #
    # @param name_or_id [String] Pod name or ID
    # @param ps_options [String, nil] Options to pass to ps command
    # @return [String] Process list output
    def top(name_or_id, ps_options: nil)
      args = ['pod', 'top', name_or_id]
      args << ps_options if ps_options
      
      @client.execute(args)
    end

    # Prune unused pods
    #
    # @param force [Boolean] Don't prompt for confirmation
    # @return [String] Prune output
    def prune(force: false)
      args = ['pod', 'prune']
      args << '--force' if force
      
      @client.execute(args)
    end
  end
end

