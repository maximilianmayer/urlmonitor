require "rake"
require "yard"
$: << File.expand_path("../lib", __FILE__)

require "urlmonitor"

LOCAL_IMAGE_NAME="/"
#UPSTREAM_IMAGE_NAME="gitlab.codecentric.de:4567/apm/instana-apiclient-ruby"
BUILD_VERSION=InstanaAPI::VERSION


desc "install dependencies"
task :install do
  sh "bundle install"
end
namespace :doc do
  desc "serve documentation"
  task :serve do
    Rake::Task['doc:generate'].invoke
    sh "yard server -r lib/"
  end

  YARD::Rake::YardocTask.new("generate") do |t|
    t.files = ["lib/"] # optional
    t.options = ["--title Instana API client"]
    t.stats_options = ['--list-undoc']         # optional
  end
end


namespace :build do
  desc "build image using docker"
  task :docker do
    BUILD_ITERATION=`docker images #{LOCAL_IMAGE_NAME} | grep #{BUILD_VERSION} | wc -l`.to_i + 1
    puts "building image with docker.."
    puts "#{LOCAL_IMAGE_NAME}:#{BUILD_VERSION}-#{BUILD_ITERATION}"
    sh "sed -i -e '/LABEL Version /s/\".*\"/\"'${version}'\"/g' Dockerfile"
    sh "docker build --no-cache -t #{LOCAL_IMAGE_NAME}:#{BUILD_VERSION}-#{BUILD_ITERATION} ."
    sh "docker tag #{LOCAL_IMAGE_NAME}:#{BUILD_VERSION}-#{BUILD_ITERATION} #{LOCAL_IMAGE_NAME}:latest"
    sh "docker tag #{LOCAL_IMAGE_NAME}:#{BUILD_VERSION}-#{BUILD_ITERATION} #{UPSTREAM_IMAGE_NAME}:#{BUILD_VERSION}-#{BUILD_ITERATION}"
    sh "docker tag #{UPSTREAM_IMAGE_NAME}:#{BUILD_VERSION}-#{BUILD_ITERATION} #{UPSTREAM_IMAGE_NAME}:latest"
  end

  desc "build image using podman"
  task :podman do
    BUILD_ITERATION=`podman images |grep #{LOCAL_IMAGE_NAME} | grep #{BUILD_VERSION} | wc -l`.to_i + 1
    puts "building image with podman.."
    puts "#{LOCAL_IMAGE_NAME}:#{BUILD_VERSION}-#{BUILD_ITERATION}"
    sh "sed -i -e '/LABEL Version /s/\".*\"/\"#{BUILD_VERSION}\"/g' Dockerfile"
    sh "podman build -t #{LOCAL_IMAGE_NAME}:#{BUILD_VERSION}-#{BUILD_ITERATION} ."
    sh "podman tag #{LOCAL_IMAGE_NAME}:#{BUILD_VERSION}-#{BUILD_ITERATION} #{LOCAL_IMAGE_NAME}:latest"
    sh "podman tag #{LOCAL_IMAGE_NAME}:#{BUILD_VERSION}-#{BUILD_ITERATION} #{UPSTREAM_IMAGE_NAME}:#{BUILD_VERSION}-#{BUILD_ITERATION}"
    sh "podman tag #{UPSTREAM_IMAGE_NAME}:#{BUILD_VERSION}-#{BUILD_ITERATION} #{UPSTREAM_IMAGE_NAME}:latest"
  end

  desc "build gem"
  task :gem do
    sh "gem build -V"
  end

  namespace :images do
    desc "upload created images"
    task :upload do
      latest_build = `podman images |grep #{UPSTREAM_IMAGE_NAME} | grep #{BUILD_VERSION}  |  awk '{print $2 }'| sort -n | tail -n1`
      sh "podman push #{UPSTREAM_IMAGE_NAME}:#{latest_build}"
      sh "podman push #{UPSTREAM_IMAGE_NAME}:latest"
    end
    desc "tag all local images with upstream"
    task :tag do
      builds = `podman images |grep #{LOCAL_IMAGE_NAME} | grep #{BUILD_VERSION} |  awk '{print $2 }'`.split("\n")
      puts builds.sort.last
    end
  end
end

