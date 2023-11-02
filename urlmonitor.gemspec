$: << File.expand_path(File.dirname(__FILE__))
$: << File.expand_path('lib',__dir__)
require 'urlmonitor'


Gem::Specification.new do |s|
  s.name              = "urlmonitor"
  s.version           = Urlmonitor::Version
  s.summary           = "pretty simple url monitor"
  s.description       = "A simple tool to monitor content changes on URLs"
  s.license           = "Apache-2.0"
  s.author            = ["Maximilian Mayer"]
  s.email             = "mayer.maximilian@gmail.com"
  s.homepage          = "https://github.com/maximilianmayer/urlmonitor"
  s.files             = `git ls-files lib`.split("\n")
  s.extra_rdoc_files  = ['Readme.md']
  s.require_paths     = ["lib"]
  s.metadata          = {
    "source_code_uri" => s.homepage,
    "bug_tracker_uri" => s.homepage + "/issues",
    "changelog_uri"   => s.homepage,
    "homepage_uri"    => s.homepage,
  }
  s.required_ruby_version     = ">= 2.6.0"

  s.add_runtime_dependency 'httparty', '~> 0.18', '>= 0.18.0'
  s.add_runtime_dependency 'commander', "~> 4"
  s.executables   << 'urlmon'
end