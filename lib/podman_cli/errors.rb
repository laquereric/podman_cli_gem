module PodmanCli
  # Base error class for all PodmanCli errors
  class Error < StandardError; end

  # Raised when podman command is not found
  class PodmanNotFoundError < Error; end

  # Raised when podman command execution fails
  class CommandError < Error
    attr_reader :command, :exit_code, :stderr

    def initialize(message, command: nil, exit_code: nil, stderr: nil)
      super(message)
      @command = command
      @exit_code = exit_code
      @stderr = stderr
    end
  end

  # Raised when container is not found
  class ContainerNotFoundError < Error; end

  # Raised when image is not found
  class ImageNotFoundError < Error; end

  # Raised when pod is not found
  class PodNotFoundError < Error; end

  # Raised when invalid arguments are provided
  class InvalidArgumentError < Error; end
end

