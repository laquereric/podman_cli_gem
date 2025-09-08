RSpec.describe PodmanCli do
  describe "Error classes" do
    describe PodmanCli::Error do
      it "is a StandardError" do
        expect(PodmanCli::Error.new).to be_a(StandardError)
      end
    end

    describe PodmanCli::PodmanNotFoundError do
      it "inherits from Error" do
        expect(PodmanCli::PodmanNotFoundError.new).to be_a(PodmanCli::Error)
      end
    end

    describe PodmanCli::CommandError do
      it "inherits from Error" do
        expect(PodmanCli::CommandError.new('test')).to be_a(PodmanCli::Error)
      end

      it "stores command details" do
        error = PodmanCli::CommandError.new(
          'Command failed',
          command: 'podman ps',
          exit_code: 1,
          stderr: 'error output'
        )

        expect(error.message).to eq('Command failed')
        expect(error.command).to eq('podman ps')
        expect(error.exit_code).to eq(1)
        expect(error.stderr).to eq('error output')
      end
    end

    describe PodmanCli::ContainerNotFoundError do
      it "inherits from Error" do
        expect(PodmanCli::ContainerNotFoundError.new).to be_a(PodmanCli::Error)
      end
    end

    describe PodmanCli::ImageNotFoundError do
      it "inherits from Error" do
        expect(PodmanCli::ImageNotFoundError.new).to be_a(PodmanCli::Error)
      end
    end

    describe PodmanCli::PodNotFoundError do
      it "inherits from Error" do
        expect(PodmanCli::PodNotFoundError.new).to be_a(PodmanCli::Error)
      end
    end

    describe PodmanCli::InvalidArgumentError do
      it "inherits from Error" do
        expect(PodmanCli::InvalidArgumentError.new).to be_a(PodmanCli::Error)
      end
    end
  end
end

