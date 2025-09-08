RSpec.describe PodmanCli::Pod do
  let(:client) { instance_double(PodmanCli::Client) }
  let(:pod) { described_class.new(client) }

  describe "#list" do
    it "lists pods with default options" do
      expect(client).to receive(:execute_json).with(['pod', 'ps']).and_return([])
      pod.list
    end

    it "applies filters" do
      expect(client).to receive(:execute_json)
        .with(['pod', 'ps', '--filter', 'status=running'])
        .and_return([])
      pod.list(filters: { status: 'running' })
    end
  end

  describe "#inspect" do
    it "inspects a pod" do
      expect(client).to receive(:execute_json)
        .with(['pod', 'inspect', 'test_pod'])
        .and_return([{ 'Id' => 'abc123' }])
      
      result = pod.inspect('test_pod')
      expect(result).to eq({ 'Id' => 'abc123' })
    end

    it "raises PodNotFoundError when pod doesn't exist" do
      error = PodmanCli::CommandError.new('error', stderr: 'no such pod')
      expect(client).to receive(:execute_json).and_raise(error)
      
      expect {
        pod.inspect('nonexistent')
      }.to raise_error(PodmanCli::PodNotFoundError)
    end
  end

  describe "#create" do
    it "creates a pod with minimal options" do
      expect(client).to receive(:execute)
        .with(['pod', 'create'])
        .and_return('abc123')
      
      result = pod.create
      expect(result).to eq('abc123')
    end

    it "creates a pod with name" do
      expect(client).to receive(:execute)
        .with(['pod', 'create', '--name', 'my_pod'])
        .and_return('abc123')
      
      pod.create(name: 'my_pod')
    end

    it "creates a pod with ports" do
      expect(client).to receive(:execute)
        .with(['pod', 'create', '--publish', '8080:80'])
        .and_return('abc123')
      
      pod.create(ports: ['8080:80'])
    end

    it "creates a pod with labels" do
      expect(client).to receive(:execute)
        .with(['pod', 'create', '--label', 'env=prod', '--label', 'app=web'])
        .and_return('abc123')
      
      pod.create(labels: { 'env' => 'prod', 'app' => 'web' })
    end

    it "creates a pod with shared namespaces" do
      expect(client).to receive(:execute)
        .with(['pod', 'create', '--share', 'net,ipc'])
        .and_return('abc123')
      
      pod.create(share: 'net,ipc')
    end
  end

  describe "#start" do
    it "starts a pod" do
      expect(client).to receive(:execute)
        .with(['pod', 'start', 'test_pod'])
        .and_return('abc123')
      
      result = pod.start('test_pod')
      expect(result).to eq('abc123')
    end
  end

  describe "#stop" do
    it "stops a pod" do
      expect(client).to receive(:execute)
        .with(['pod', 'stop', 'test_pod'])
        .and_return('abc123')
      
      pod.stop('test_pod')
    end

    it "stops a pod with timeout" do
      expect(client).to receive(:execute)
        .with(['pod', 'stop', '--time', '30', 'test_pod'])
        .and_return('abc123')
      
      pod.stop('test_pod', timeout: 30)
    end
  end

  describe "#restart" do
    it "restarts a pod" do
      expect(client).to receive(:execute)
        .with(['pod', 'restart', 'test_pod'])
        .and_return('abc123')
      
      result = pod.restart('test_pod')
      expect(result).to eq('abc123')
    end
  end

  describe "#pause" do
    it "pauses a pod" do
      expect(client).to receive(:execute)
        .with(['pod', 'pause', 'test_pod'])
        .and_return('abc123')
      
      result = pod.pause('test_pod')
      expect(result).to eq('abc123')
    end
  end

  describe "#unpause" do
    it "unpauses a pod" do
      expect(client).to receive(:execute)
        .with(['pod', 'unpause', 'test_pod'])
        .and_return('abc123')
      
      result = pod.unpause('test_pod')
      expect(result).to eq('abc123')
    end
  end

  describe "#remove" do
    it "removes a pod" do
      expect(client).to receive(:execute)
        .with(['pod', 'rm', 'test_pod'])
        .and_return('abc123')
      
      pod.remove('test_pod')
    end

    it "force removes a pod" do
      expect(client).to receive(:execute)
        .with(['pod', 'rm', '--force', 'test_pod'])
        .and_return('abc123')
      
      pod.remove('test_pod', force: true)
    end
  end

  describe "#kill" do
    it "kills a pod" do
      expect(client).to receive(:execute)
        .with(['pod', 'kill', 'test_pod'])
        .and_return('abc123')
      
      result = pod.kill('test_pod')
      expect(result).to eq('abc123')
    end

    it "kills a pod with signal" do
      expect(client).to receive(:execute)
        .with(['pod', 'kill', '--signal', 'SIGTERM', 'test_pod'])
        .and_return('abc123')
      
      pod.kill('test_pod', signal: 'SIGTERM')
    end
  end

  describe "#stats" do
    it "gets pod stats" do
      expect(client).to receive(:execute)
        .with(['pod', 'stats', '--no-stream'])
        .and_return('stats output')
      
      result = pod.stats
      expect(result).to eq('stats output')
    end

    it "gets stats for specific pod" do
      expect(client).to receive(:execute)
        .with(['pod', 'stats', '--no-stream', 'test_pod'])
        .and_return('stats output')
      
      pod.stats('test_pod')
    end
  end

  describe "#top" do
    it "gets pod processes" do
      expect(client).to receive(:execute)
        .with(['pod', 'top', 'test_pod'])
        .and_return('process list')
      
      result = pod.top('test_pod')
      expect(result).to eq('process list')
    end

    it "gets pod processes with ps options" do
      expect(client).to receive(:execute)
        .with(['pod', 'top', 'test_pod', 'aux'])
        .and_return('process list')
      
      pod.top('test_pod', ps_options: 'aux')
    end
  end

  describe "#prune" do
    it "prunes unused pods" do
      expect(client).to receive(:execute)
        .with(['pod', 'prune'])
        .and_return('Pruned pods')
      
      result = pod.prune
      expect(result).to eq('Pruned pods')
    end

    it "force prunes unused pods" do
      expect(client).to receive(:execute)
        .with(['pod', 'prune', '--force'])
        .and_return('Pruned pods')
      
      pod.prune(force: true)
    end
  end
end

