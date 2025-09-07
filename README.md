


# Podman CLI Gem

[![Gem Version](https://badge.fury.io/rb/podman_cli.svg)](https://badge.fury.io/rb/podman_cli)
[![Build Status](https://github.com/manus-ai/podman_cli/actions/workflows/ci.yml/badge.svg)](https://github.com/manus-ai/podman_cli/actions/workflows/ci.yml)

A Ruby gem that provides a programmatic wrapper around the Podman CLI, allowing Ruby developers to interact with Podman containers, images, and pods through a simple and intuitive object-oriented interface.

This gem is designed to be a comprehensive and easy-to-use tool for managing Podman resources from within your Ruby applications. It provides a clean and modern API that abstracts away the complexities of the Podman command-line interface.




## Installation

Add this line to your application's Gemfile:

```ruby
gem 'podman_cli'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install podman_cli
```

### Prerequisites

This gem requires a working installation of Podman on your system. You can find installation instructions for your operating system on the [official Podman website](https://podman.io/getting-started/installation).




## Usage

Here are some examples of how to use the `podman_cli` gem to manage your Podman resources.

### Creating a Client

First, create a new client instance to interact with Podman:

```ruby
require 'podman_cli'

# Create a client with the default podman path
client = PodmanCli.new

# Or specify a custom path to the podman executable
client = PodmanCli.new(podman_path: '/usr/local/bin/podman')
```

### Managing Containers

```ruby
# List all running containers
containers = client.containers.list

# List all containers, including stopped ones
all_containers = client.containers.list(all: true)

# Create and run a new container
container_id = client.containers.run('nginx:latest', name: 'my_nginx', ports: ['8080:80'], detach: true)

# Inspect a container
container_info = client.containers.inspect('my_nginx')

# Stop and remove a container
client.containers.stop('my_nginx')
client.containers.remove('my_nginx')
```

### Managing Images

```ruby
# List all images
images = client.images.list

# Pull an image from a registry
client.images.pull('alpine:latest')

# Inspect an image
image_info = client.images.inspect('alpine:latest')

# Remove an image
client.images.remove('alpine:latest')
```

### Managing Pods

```ruby
# Create a new pod
pod_id = client.pods.create(name: 'my_pod', ports: ['8080:80'])

# List all pods
pods = client.pods.list

# Inspect a pod
pod_info = client.pods.inspect('my_pod')

# Stop and remove a pod
client.pods.stop('my_pod')
client.pods.remove('my_pod')
```




## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `bundle exec rspec` to run the tests. You can also run `bundle exec rake` to run both the tests and RuboCop for code style checking.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `lib/podman_cli/version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/manus-ai/podman_cli. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/manus-ai/podman_cli/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the PodmanCli project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/manus-ai/podman_cli/blob/main/CODE_OF_CONDUCT.md).


# podman_cli_gem
