RSpec.describe PodmanCli do
  it "has a version number" do
    expect(PodmanCli::VERSION).not_to be nil
  end

  describe ".new" do
    it "creates a new client instance" do
      client = PodmanCli.new(podman_path: 'echo')
      expect(client).to be_a(PodmanCli::Client)
    end

    it "accepts custom podman path" do
      client = PodmanCli.new(podman_path: 'echo')
      expect(client.podman_path).to eq('echo')
    end
  end
end

