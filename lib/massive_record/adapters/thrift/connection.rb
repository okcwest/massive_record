require 'active_support/notifications'

module MassiveRecord
  module Adapters
    module Thrift
      class Connection

        attr_accessor :host, :port, :timeout

        def initialize(opts = {})
          @timeout = opts[:timeout] || 4
          @host = opts[:host]
          @port = opts[:port] || 9090
          @instrumenter = ActiveSupport::Notifications.instrumenter
        end

        def transport
          @transport ||= ::Thrift::BufferedTransport.new(::Thrift::Socket.new(@host, @port, @timeout))
        end

        def open(options = {})
          options = options.merge({
                                      :adapter => 'Thrift',
                                      :host => @host,
                                      :port => @port
                                  })

          @instrumenter.instrument "adapter_connecting.massive_record", options do
            protocol = ::Thrift::BinaryProtocolAccelerated.new(transport)
            @client = Apache::Hadoop::Hbase::Thrift::Hbase::Client.new(protocol)

            begin
              transport.open()
              true
            rescue
              raise MassiveRecord::Wrapper::Errors::ConnectionException.new, "Unable to connect to HBase on #{@host}, port #{@port}"
            end
          end
        end

        def close
          @transport.nil? || @transport.close.nil?
        rescue IOError
          true
        end

        def client
          @client
        end

        def open?
          @transport.try("open?")
        end

        def tables
          start_time = DateTime.current
          begin
            collection = MassiveRecord::Wrapper::TablesCollection.new
            collection.connection = self
            (getTableNames() || {}).each { |table_name| collection.push(table_name) }
            collection
          rescue => e
            if reconnect?(e, start_time)
              reconnect!(e)
              retry
            else
              raise e
            end
          end
        end

        def load_table(table_name)
          MassiveRecord::Wrapper::Table.new(self, table_name)
        end

        # Wrapp HBase API to be able to catch errors and try reconnect
        def method_missing(method, *args)
          start_time = DateTime.current
          begin
            open if not client
            client.send(method, *args) if client
          rescue => e
            if reconnect?(e, start_time)
              reconnect!(e)
              retry
            else
              raise e
            end
          end
        end

        private

        # Unstable or closed connection:
        # IOError: unable to perform a read or write
        # TransportException: some packets where lost
        # ApplicationException: issue to get data
        def reconnect?(e, start_time)
          time_spent = Time.now - start_time
          time_spent < @timeout && (
          (e.is_a?(::Apache::Hadoop::Hbase::Thrift::IOError) && e.message.include?("closed stream")) ||
              e.is_a?(::Thrift::TransportException) ||
              e.is_a?(::Thrift::ApplicationException)
          )
        end

        def reconnect!(e)
          close
          sleep 1
          @transport = nil
          @client = nil
          open(:reconnecting => true, :reason => e.class)
        end

      end
    end
  end
end
