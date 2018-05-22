
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "google_directory/version"

Gem::Specification.new do |spec|
  spec.name          = "google_directory"
  spec.version       = GoogleDirectory::Version::VERSION
  spec.authors       = ["Bill Tihen", "Lee Weisbecker"]
  spec.email         = ["btihen@gmail.com", "lweisbecker@las.ch"]

  spec.summary       = %q{Simple ruby wrapper to manage google accounts - using oauth2.}
  spec.description   = %q{Authenticate, list, make, check, suspend and activate google users.}
  spec.homepage      = "https://github.com/LAS-IT/google_directory"
  spec.license       = "MIT"

  # # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  # https://stackoverflow.com/questions/27790712/making-a-ruby-gem-cannot-load-such-file?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
  # spec.require_paths = ["lib"]
  spec.files = Dir['lib/**/*.rb']
  # spec.files = ['lib/google_directory.rb',
  #               'lib/google_directory/connection.rb',
  #               'lib/google_directory/user_commands.rb']

  spec.add_dependency "google-api-client", "~> 0.21"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  # spec.add_development_dependency "rake", "~> 12.3"
  # spec.add_development_dependency "rspec", "~> 3.7"
  spec.add_development_dependency "pry", "~> 0.11"
end
