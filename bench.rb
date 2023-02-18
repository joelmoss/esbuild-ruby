#!/usr/bin/env ruby
# frozen_string_literal: true

require 'esbuild'
require 'benchmark/ips'
require 'open3'

puts RUBY_DESCRIPTION

input = 'const number = 1;'

Benchmark.ips do |x|
  x.report('esbuild-cli') { Open3.capture3("echo '#{input}' | bin/esbuild") }
  x.report('esbuild transform') { Esbuild.transform(input) }
  x.report('esbuild build') do
    Esbuild.build(stdin: { contents: input, sourcefile: 'source.js' }, write: false, metafile: true)
  end
  x.compare!
end
