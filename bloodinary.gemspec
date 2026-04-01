lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "bloodinary"
  spec.version       = "1.0.0"
  spec.authors       = ["IshikawaUta"]
  spec.email         = ["komikers09@gmail.com"]

  spec.summary       = "Premium static analysis security testing (SAST) for Ruby applications."
  spec.description   = "Bloodinary detects high-severity vulnerabilities like SQLi, XSS, and RCE in any Ruby application, including custom frameworks."
  spec.homepage      = "https://github.com/IshikawaUta/bloodinary"
  spec.license       = "MIT"

  spec.files         = Dir["{bin,lib}/**/*", "LICENSE", "README.md", "assets/logo.png"]
  spec.bindir        = "bin"
  spec.executables   = ["bloodinary"]
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 3.0.0"

  spec.add_dependency "parser", "~> 3.0"
  spec.add_dependency "rainbow", "~> 3.0"

  spec.add_development_dependency "bundler", "~> 2.3"
  spec.add_development_dependency "rake", "~> 13.0"
end
