# frozen_string_literal: true

require 'zeitwerk'
require 'concurrent'

loader = Zeitwerk::Loader.for_gem
loader.setup

module Esbuild
  class << self
    def build(options)
      service.build_or_serve(options)
    end

    def serve(serve_options, build_options)
      service.build_or_serve(build_options, serve_options)
    end

    def transform(input, options = {})
      service.transform(input, options)
    end

    private

    def service
      @service ||= Service.new
    end
  end
end
