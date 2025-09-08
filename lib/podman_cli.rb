require_relative "podman_cli/version"
require_relative "podman_cli/client"
require_relative "podman_cli/container"
require_relative "podman_cli/image"
require_relative "podman_cli/pod"
require_relative "podman_cli/errors"

module PodmanCli
  class Error < StandardError; end

  # Create a new Podman client instance
  #
  # @param podman_path [String] Path to the podman executable (default: 'podman')
  # @return [PodmanCli::Client] A new client instance
  def self.new(podman_path: 'podman')
    Client.new(podman_path: podman_path)
  end
end

