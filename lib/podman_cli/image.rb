module PodmanCli
  # Image management interface
  class Image
    def initialize(client)
      @client = client
    end

    # List all images
    #
    # @param all [Boolean] Show all images including intermediate layers
    # @param filters [Hash] Filters to apply (e.g., { dangling: true })
    # @return [Array<Hash>] Array of image information
    def list(all: false, filters: {})
      args = ['images']
      args << '--all' if all
      
      filters.each do |key, value|
        args << '--filter' << "#{key}=#{value}"
      end

      @client.execute_json(args)
    end

    # Get detailed information about an image
    #
    # @param name_or_id [String] Image name or ID
    # @return [Hash] Image information
    # @raise [ImageNotFoundError] If image is not found
    def inspect(name_or_id)
      result = @client.execute_json(['inspect', name_or_id])
      result.first
    rescue CommandError => e
      if e.stderr&.include?('no such image')
        raise ImageNotFoundError.new("Image not found: #{name_or_id}")
      end
      raise
    end

    # Pull an image from a registry
    #
    # @param name [String] Image name (e.g., 'nginx:latest')
    # @param all_tags [Boolean] Pull all tags for the image
    # @return [String] Pull output
    def pull(name, all_tags: false)
      args = ['pull']
      args << '--all-tags' if all_tags
      args << name
      
      @client.execute(args)
    end

    # Push an image to a registry
    #
    # @param name [String] Image name
    # @param all_tags [Boolean] Push all tags for the image
    # @return [String] Push output
    def push(name, all_tags: false)
      args = ['push']
      args << '--all-tags' if all_tags
      args << name
      
      @client.execute(args)
    end

    # Remove an image
    #
    # @param name_or_id [String] Image name or ID
    # @param force [Boolean] Force removal of image
    # @return [String] Remove output
    def remove(name_or_id, force: false)
      args = ['rmi']
      args << '--force' if force
      args << name_or_id
      
      @client.execute(args)
    end

    # Tag an image
    #
    # @param source [String] Source image name or ID
    # @param target [String] Target image name and tag
    # @return [String] Tag output
    def tag(source, target)
      @client.execute(['tag', source, target])
    end

    # Build an image from a Dockerfile
    #
    # @param context [String] Build context path
    # @param tag [String, nil] Tag for the built image
    # @param dockerfile [String, nil] Path to Dockerfile (relative to context)
    # @param build_args [Hash] Build arguments
    # @param no_cache [Boolean] Don't use cache when building
    # @return [String] Build output
    def build(context, tag: nil, dockerfile: nil, build_args: {}, no_cache: false)
      args = ['build']
      
      args.concat(['--tag', tag]) if tag
      args.concat(['--file', dockerfile]) if dockerfile
      args << '--no-cache' if no_cache
      
      build_args.each do |key, value|
        args.concat(['--build-arg', "#{key}=#{value}"])
      end
      
      args << context
      
      @client.execute(args)
    end

    # Search for images in registries
    #
    # @param term [String] Search term
    # @param limit [Integer, nil] Limit number of results
    # @param filters [Hash] Search filters
    # @return [Array<Hash>] Search results
    def search(term, limit: nil, filters: {})
      args = ['search']
      args.concat(['--limit', limit.to_s]) if limit
      
      filters.each do |key, value|
        args << '--filter' << "#{key}=#{value}"
      end
      
      args << term
      
      @client.execute_json(args)
    end

    # Get image history
    #
    # @param name_or_id [String] Image name or ID
    # @return [Array<Hash>] Image history
    def history(name_or_id)
      @client.execute_json(['history', name_or_id])
    end

    # Save images to a tar archive
    #
    # @param images [Array<String>] Image names or IDs
    # @param output [String] Output file path
    # @return [String] Save output
    def save(images, output:)
      args = ['save', '--output', output]
      args.concat(images)
      
      @client.execute(args)
    end

    # Load images from a tar archive
    #
    # @param input [String] Input file path
    # @return [String] Load output
    def load(input:)
      @client.execute(['load', '--input', input])
    end

    # Import a tarball to create a filesystem image
    #
    # @param source [String] Source tarball path or URL
    # @param reference [String, nil] Repository name for imported image
    # @return [String] Import output
    def import(source, reference: nil)
      args = ['import']
      args << source
      args << reference if reference
      
      @client.execute(args)
    end

    # Export a container's filesystem as a tar archive
    #
    # @param container [String] Container name or ID
    # @param output [String] Output file path
    # @return [String] Export output
    def export(container, output:)
      @client.execute(['export', '--output', output, container])
    end

    # Prune unused images
    #
    # @param all [Boolean] Remove all unused images, not just dangling ones
    # @param force [Boolean] Don't prompt for confirmation
    # @return [String] Prune output
    def prune(all: false, force: false)
      args = ['image', 'prune']
      args << '--all' if all
      args << '--force' if force
      
      @client.execute(args)
    end
  end
end

