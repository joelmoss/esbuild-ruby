# frozen_string_literal: true

require 'esbuild'
require 'bundler'

Bundler.require :test

Zeitwerk::Loader.eager_load_all
