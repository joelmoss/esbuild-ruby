module Esbuild
  class BuildState
    def initialize(service, on_rebuild)
      @service = service
      @rebuild_id = nil
      @watch_id = nil
      @on_rebuild = on_rebuild
    end

    def stop
      return unless @watch_id

      @service.stop_watch(@watch_id)
      @watch_id = nil
    end

    def dispose
      return unless @rebuild_id

      res = @service.send_request('command' => 'rebuild-dispose', 'rebuildID' => @rebuild_id)
      @rebuild_id = nil
      res
    end

    def rebuild
      raise 'Cannot rebuild' if @rebuild_id.nil?

      rebuild_response = @service.send_request('command' => 'rebuild', 'rebuildID' => @rebuild_id)
      response_to_result(rebuild_response)
    end

    def handle_watch(error, response)
      return @on_rebuild.call(error, nil) if error

      unless response['errors'].empty?
        error = BuildFailureError.new(response['errors'], response['warnings'])
        @on_rebuild.call(error, nil)
        return
      end

      result = BuildResult.new(response, self)
      @on_rebuild.call(nil, result)
    end

    def response_to_result(res)
      raise BuildFailureError.new(res['errors'], res['warnings']) unless res['errors'].empty?

      $stdout.puts res['writeToStdout'].rstrip if res['writeToStdout']

      result = BuildResult.new(res, self)

      # Handle incremental rebuilds
      @rebuild_id = res['rebuildID'] if res['rebuildID'] && !@rebuild_id

      # Handle watch mode
      if res['watchID'] && !@watch_id
        @watch_id = res['watchID']
        if @on_rebuild
          @service.start_watch(@watch_id, ->(error, watch_response) { handle_watch(error, watch_response) })
        end
      end
      result
    end
  end
end
