RSpec.describe PodmanCli::Image do
  let(:client) { instance_double(PodmanCli::Client) }
  let(:image) { described_class.new(client) }

  describe "#list" do
    it "lists images with default options" do
      expect(client).to receive(:execute_json).with(['images']).and_return([])
      image.list
    end

    it "lists all images when all: true" do
      expect(client).to receive(:execute_json).with(['images', '--all']).and_return([])
      image.list(all: true)
    end

    it "applies filters" do
      expect(client).to receive(:execute_json)
        .with(['images', '--filter', 'dangling=true'])
        .and_return([])
      image.list(filters: { dangling: true })
    end
  end

  describe "#inspect" do
    it "inspects an image" do
      expect(client).to receive(:execute_json)
        .with(['inspect', 'nginx'])
        .and_return([{ 'Id' => 'sha256:abc123' }])
      
      result = image.inspect('nginx')
      expect(result).to eq({ 'Id' => 'sha256:abc123' })
    end

    it "raises ImageNotFoundError when image doesn't exist" do
      error = PodmanCli::CommandError.new('error', stderr: 'no such image')
      expect(client).to receive(:execute_json).and_raise(error)
      
      expect {
        image.inspect('nonexistent')
      }.to raise_error(PodmanCli::ImageNotFoundError)
    end
  end

  describe "#pull" do
    it "pulls an image" do
      expect(client).to receive(:execute)
        .with(['pull', 'nginx:latest'])
        .and_return('Pulled nginx:latest')
      
      result = image.pull('nginx:latest')
      expect(result).to eq('Pulled nginx:latest')
    end

    it "pulls all tags" do
      expect(client).to receive(:execute)
        .with(['pull', '--all-tags', 'nginx'])
        .and_return('Pulled all tags')
      
      image.pull('nginx', all_tags: true)
    end
  end

  describe "#push" do
    it "pushes an image" do
      expect(client).to receive(:execute)
        .with(['push', 'my-registry/nginx'])
        .and_return('Pushed image')
      
      result = image.push('my-registry/nginx')
      expect(result).to eq('Pushed image')
    end
  end

  describe "#remove" do
    it "removes an image" do
      expect(client).to receive(:execute)
        .with(['rmi', 'nginx'])
        .and_return('Removed nginx')
      
      result = image.remove('nginx')
      expect(result).to eq('Removed nginx')
    end

    it "force removes an image" do
      expect(client).to receive(:execute)
        .with(['rmi', '--force', 'nginx'])
        .and_return('Force removed nginx')
      
      image.remove('nginx', force: true)
    end
  end

  describe "#tag" do
    it "tags an image" do
      expect(client).to receive(:execute)
        .with(['tag', 'nginx', 'my-nginx:v1'])
        .and_return('')
      
      image.tag('nginx', 'my-nginx:v1')
    end
  end

  describe "#build" do
    it "builds an image" do
      expect(client).to receive(:execute)
        .with(['build', '/path/to/context'])
        .and_return('Built image')
      
      result = image.build('/path/to/context')
      expect(result).to eq('Built image')
    end

    it "builds with tag" do
      expect(client).to receive(:execute)
        .with(['build', '--tag', 'my-app:latest', '/path/to/context'])
        .and_return('Built image')
      
      image.build('/path/to/context', tag: 'my-app:latest')
    end

    it "builds with dockerfile" do
      expect(client).to receive(:execute)
        .with(['build', '--file', 'Dockerfile.prod', '/path/to/context'])
        .and_return('Built image')
      
      image.build('/path/to/context', dockerfile: 'Dockerfile.prod')
    end

    it "builds with build args" do
      expect(client).to receive(:execute)
        .with(['build', '--build-arg', 'VERSION=1.0', '--build-arg', 'ENV=prod', '/path/to/context'])
        .and_return('Built image')
      
      image.build('/path/to/context', build_args: { 'VERSION' => '1.0', 'ENV' => 'prod' })
    end
  end

  describe "#search" do
    it "searches for images" do
      expect(client).to receive(:execute_json)
        .with(['search', 'nginx'])
        .and_return([{ 'Name' => 'nginx' }])
      
      result = image.search('nginx')
      expect(result).to eq([{ 'Name' => 'nginx' }])
    end

    it "searches with limit" do
      expect(client).to receive(:execute_json)
        .with(['search', '--limit', '10', 'nginx'])
        .and_return([])
      
      image.search('nginx', limit: 10)
    end
  end

  describe "#history" do
    it "gets image history" do
      expect(client).to receive(:execute_json)
        .with(['history', 'nginx'])
        .and_return([{ 'Id' => 'abc123' }])
      
      result = image.history('nginx')
      expect(result).to eq([{ 'Id' => 'abc123' }])
    end
  end

  describe "#save" do
    it "saves images to tar" do
      expect(client).to receive(:execute)
        .with(['save', '--output', '/tmp/images.tar', 'nginx', 'alpine'])
        .and_return('Saved images')
      
      result = image.save(['nginx', 'alpine'], output: '/tmp/images.tar')
      expect(result).to eq('Saved images')
    end
  end

  describe "#load" do
    it "loads images from tar" do
      expect(client).to receive(:execute)
        .with(['load', '--input', '/tmp/images.tar'])
        .and_return('Loaded images')
      
      result = image.load(input: '/tmp/images.tar')
      expect(result).to eq('Loaded images')
    end
  end
end

