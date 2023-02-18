#!/usr/bin/env ruby
# frozen_string_literal: true

require "esbuild"
require "benchmark/ips"
require "open3"

puts RUBY_DESCRIPTION

input = "const number = 1;"

Benchmark.ips do |x|
  x.report("esbuild-cli") { Open3.capture3("echo '#{input}' | bin/esbuild") }
  x.report("esbuild transform") { Esbuild.transform(input) }
  x.report("esbuild build") do
    Esbuild.build(stdin: {contents: input, sourcefile: "source.js"}, write: false, metafile: true)
  end
  x.compare!
end

# RESULTS
#
# ruby 3.2.1 (2023-02-08 revision 31819e82c8) [arm64-darwin22]
#
# Warming up --------------------------------------
#          esbuild-cli    12.000  i/100ms
#    esbuild transform   512.000  i/100ms
#        esbuild build   254.000  i/100ms
# Calculating -------------------------------------
#          esbuild-cli    124.978  (± 2.4%) i/s -    636.000  in   5.091248s
#    esbuild transform      5.100k (± 2.2%) i/s -     25.600k in   5.021731s
#        esbuild build      2.516k (± 2.6%) i/s -     12.700k in   5.050991s
#
# Comparison:
#    esbuild transform:     5100.5 i/s
#        esbuild build:     2516.3 i/s - 2.03x  slower
#          esbuild-cli:      125.0 i/s - 40.81x  slower
