require_relative 'lib/podman_cli/version'

Gem::Specification.new do |spec|
  spec.name          = "podman_cli"
  spec.version       = PodmanCli::VERSION
  spec.authors       = ["Manus AI"]
  spec.email         = ["support@manus.im"]

  spec.summary       = "Ruby wrapper for Podman CLI"
  spec.description   = "A Ruby gem that provides a programmatic interface to Podman container management through CLI commands"
  spec.homepage      = "https://github.com/manus-ai/podman_cli"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0", "< 4.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/manus-ai/podman_cli"
  spec.metadata["changelog_uri"] = "https://github.com/manus-ai/podman_cli/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Runtime dependencies
  spec.add_dependency "json", "~> 2.0"

  # Development dependencies
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "cucumber", "~> 8.0"
  spec.add_development_dependency "yard", "~> 0.9"
  spec.add_development_dependency "rubocop", "~> 1.0"
end

