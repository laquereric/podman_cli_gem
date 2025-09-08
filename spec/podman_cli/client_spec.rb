RSpec.describe PodmanCli::Client do
  describe "#initialize" do
    context "when podman is found" do
      let(:client) { described_class.new(podman_path: 'echo') }

      it "sets the podman path" do
        expect(client.podman_path).to eq('echo')
      end
    end

    context "when podman is not found" do
      it "raises PodmanNotFoundError" do
        expect {
          described_class.new(podman_path: 'nonexistent_command')
        }.to raise_error(PodmanCli::PodmanNotFoundError)
      end
    end
  end

  describe "#execute" do
    let(:client) { described_class.new(podman_path: 'echo') }

    it "executes commands and returns output" do
      result = client.execute(['hello', 'world'])
      expect(result).to eq('hello world')
    end
  end

  describe "management interfaces" do
    let(:client) { described_class.new(podman_path: 'echo') }

    describe "#containers" do
      it "returns a Container instance" do
        expect(client.containers).to be_a(PodmanCli::Container)
      end

      it "memoizes the instance" do
        expect(client.containers).to be(client.containers)
      end
    end

    describe "#images" do
      it "returns an Image instance" do
        expect(client.images).to be_a(PodmanCli::Image)
      end

      it "memoizes the instance" do
        expect(client.images).to be(client.images)
      end
    end

    describe "#pods" do
      it "returns a Pod instance" do
        expect(client.pods).to be_a(PodmanCli::Pod)
      end

      it "memoizes the instance" do
        expect(client.pods).to be(client.pods)
      end
    end
  end
end

