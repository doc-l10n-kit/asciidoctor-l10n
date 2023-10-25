# frozen_string_literal: true

require_relative "lib/jekyll/l10n/version"

Gem::Specification.new do |spec|
  spec.name = "jekyll-l10n"
  spec.version = Jekyll::L10n::VERSION
  spec.authors = ["Yoshikazu Nojima"]
  spec.email = ["mail@ynojima.net"]

  spec.summary = "Jekyll localization extension"
  spec.description = "Jekyll localization extension implemented as tree processor extension"
  spec.homepage = "https://github.com/doc-l10n-kit/jekyll-l10n"
  spec.required_ruby_version = ">= 2.6.0"

  #  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/doc-l10n-kit/jekyll-l10n"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "asciidoctor"
  spec.add_dependency "jekyll"
  spec.add_dependency "gettext", "3.4.9"


end
