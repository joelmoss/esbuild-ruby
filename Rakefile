# frozen_string_literal: true

require 'bundler/setup'
require 'bundler/gem_tasks'
require 'standard/rake'

task :download_binary do
  require_relative 'lib/esbuild/binary_installer'
  esbuild_bin = File.join(__dir__, 'bin', 'esbuild')
  installer = Esbuild::BinaryInstaller.new(RUBY_PLATFORM, esbuild_bin)
  installer.install
end

task :test do
  sh 'bundle exec sus'
end

task default: [:test, 'standard:fix']
