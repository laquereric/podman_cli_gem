RSpec.describe PodmanCli::Container do
  let(:client) { instance_double(PodmanCli::Client) }
  let(:container) { described_class.new(client) }

  describe "#list" do
    it "lists containers with default options" do
      expect(client).to receive(:execute_json).with(['ps']).and_return([])
      container.list
    end

    it "lists all containers when all: true" do
      expect(client).to receive(:execute_json).with(['ps', '--all']).and_return([])
      container.list(all: true)
    end

    it "applies filters" do
      expect(client).to receive(:execute_json)
        .with(['ps', '--filter', 'status=running'])
        .and_return([])
      container.list(filters: { status: 'running' })
    end
  end

  describe "#inspect" do
    it "inspects a container" do
      expect(client).to receive(:execute_json)
        .with(['inspect', 'test_container'])
        .and_return([{ 'Id' => 'abc123' }])
      
      result = container.inspect('test_container')
      expect(result).to eq({ 'Id' => 'abc123' })
    end

    it "raises ContainerNotFoundError when container doesn't exist" do
      error = PodmanCli::CommandError.new('error', stderr: 'no such container')
      expect(client).to receive(:execute_json).and_raise(error)
      
      expect {
        container.inspect('nonexistent')
      }.to raise_error(PodmanCli::ContainerNotFoundError)
    end
  end

  describe "#create" do
    it "creates a container with minimal options" do
      expect(client).to receive(:execute)
        .with(['create', 'nginx'])
        .and_return('abc123')
      
      result = container.create('nginx')
      expect(result).to eq('abc123')
    end

    it "creates a container with name" do
      expect(client).to receive(:execute)
        .with(['create', '--name', 'my_nginx', 'nginx'])
        .and_return('abc123')
      
      container.create('nginx', name: 'my_nginx')
    end

    it "creates a container with ports" do
      expect(client).to receive(:execute)
        .with(['create', '--publish', '8080:80', 'nginx'])
        .and_return('abc123')
      
      container.create('nginx', ports: ['8080:80'])
    end

    it "creates a container with environment variables" do
      expect(client).to receive(:execute)
        .with(['create', '--env', 'FOO=bar', '--env', 'BAZ=qux', 'nginx'])
        .and_return('abc123')
      
      container.create('nginx', env: { 'FOO' => 'bar', 'BAZ' => 'qux' })
    end
  end

  describe "#start" do
    it "starts a container" do
      expect(client).to receive(:execute)
        .with(['start', 'test_container'])
        .and_return('abc123')
      
      result = container.start('test_container')
      expect(result).to eq('abc123')
    end
  end

  describe "#stop" do
    it "stops a container" do
      expect(client).to receive(:execute)
        .with(['stop', 'test_container'])
        .and_return('abc123')
      
      container.stop('test_container')
    end

    it "stops a container with timeout" do
      expect(client).to receive(:execute)
        .with(['stop', '--time', '30', 'test_container'])
        .and_return('abc123')
      
      container.stop('test_container', timeout: 30)
    end
  end

  describe "#remove" do
    it "removes a container" do
      expect(client).to receive(:execute)
        .with(['rm', 'test_container'])
        .and_return('abc123')
      
      container.remove('test_container')
    end

    it "force removes a container" do
      expect(client).to receive(:execute)
        .with(['rm', '--force', 'test_container'])
        .and_return('abc123')
      
      container.remove('test_container', force: true)
    end
  end

  describe "#run" do
    it "runs a container" do
      expect(client).to receive(:execute)
        .with(['run', 'nginx'])
        .and_return('output')
      
      result = container.run('nginx')
      expect(result).to eq('output')
    end

    it "runs a detached container" do
      expect(client).to receive(:execute)
        .with(['run', '--detach', 'nginx'])
        .and_return('abc123')
      
      container.run('nginx', detach: true)
    end
  end
end

