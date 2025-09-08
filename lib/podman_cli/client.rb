require 'open3'
require 'json'

module PodmanCli
  # Main client class for interacting with Podman CLI
  class Client
    attr_reader :podman_path

    # Initialize a new Podman client
    #
    # @param podman_path [String] Path to the podman executable
    def initialize(podman_path: 'podman')
      @podman_path = podman_path
      validate_podman_installation!
    end

    # Get container management interface
    #
    # @return [PodmanCli::Container] Container management instance
    def containers
      @containers ||= Container.new(self)
    end

    # Get image management interface
    #
    # @return [PodmanCli::Image] Image management instance
    def images
      @images ||= Image.new(self)
    end

    # Get pod management interface
    #
    # @return [PodmanCli::Pod] Pod management instance
    def pods
      @pods ||= Pod.new(self)
    end

    # Execute a podman command
    #
    # @param args [Array<String>] Command arguments
    # @param capture_output [Boolean] Whether to capture and return output
    # @return [String, nil] Command output if capture_output is true
    # @raise [CommandError] If command execution fails
    def execute(args, capture_output: true)
      command = [podman_path] + args
      
      if capture_output
        stdout, stderr, status = Open3.capture3(*command)
        
        unless status.success?
          raise CommandError.new(
            "Command failed: #{command.join(' ')}",
            command: command.join(' '),
            exit_code: status.exitstatus,
            stderr: stderr
          )
        end
        
        stdout.strip
      else
        success = system(*command)
        
        unless success
          raise CommandError.new(
            "Command failed: #{command.join(' ')}",
            command: command.join(' '),
            exit_code: $?.exitstatus
          )
        end
        
        nil
      end
    end

    # Execute a podman command and parse JSON output
    #
    # @param args [Array<String>] Command arguments
    # @return [Hash, Array] Parsed JSON output
    def execute_json(args)
      output = execute(args + ['--format', 'json'])
      return [] if output.empty?
      
      JSON.parse(output)
    rescue JSON::ParserError => e
      raise CommandError.new("Failed to parse JSON output: #{e.message}")
    end

    # Get podman version information
    #
    # @return [Hash] Version information
    def version
      output = execute(['version', '--format', 'json'])
      JSON.parse(output)
    rescue JSON::ParserError
      # Fallback for older podman versions
      output = execute(['version'])
      { 'version' => output.split("\n").first }
    end

    # Get podman system information
    #
    # @return [Hash] System information
    def info
      execute_json(['info'])
    end

    private

    # Validate that podman is installed and accessible
    def validate_podman_installation!
      execute(['--version'])
    rescue CommandError, Errno::ENOENT
      raise PodmanNotFoundError.new("Podman not found at: #{podman_path}")
    end
  end
end

