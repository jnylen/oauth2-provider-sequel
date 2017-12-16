module TestApp

  class User < Sequel::Model(:users)
    plugin :oauth2_client_owner
    plugin :oauth2_resource_owner

    def self.[](name)
      find_or_create(:name => name)
    end
  end

  module Helper
    module RackRunner
      def start(port)
        handler = Rack::Handler.get('thin')
        Thread.new do
          handler.run(new, :Port => port) { |server| @server = server }
        end
        sleep 0.1 until @server
      end

      def stop
        @server.stop if @server
        @server = nil
        sleep 0.1 while EM.reactor_running?
      end
    end
  end

end
