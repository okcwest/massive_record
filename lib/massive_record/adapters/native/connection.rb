module MassiveRecord
  module Adapters
    module Native
      class Connection
  
        attr_accessor :host, :port, :timeout
    
        def initialize(opts = {})
          @timeout = 4000
          @host    = opts[:host]
          @port    = opts[:port] || 9090
        end
      
        def configuration
          c = HBaseConfiguration.create
          c.set("hbase.master", "#{host}:#{port}")
          c.set("hbase.zookeeper.quorum", host)
          c.set("hbase.zookeeper.property.clientPort", "2181")
          c
        end
      
        def open
          begin
            HBaseAdmin.checkHBaseAvailable(configuration)
            @client = HBaseAdmin.new(configuration)
            true
          rescue => ex
            raise MassiveRecord::Wrapper::Errors::ConnectionException.new, "Unable to connect to HBase on #{@host}, port #{@port} (#{ex.class.to_s})"
          end
        end
      
        def close
          @client = nil
          true
        end
          
        def client
          @client
        end
      
        def open?
          !@client.nil?
        end
      
        def tables
          collection = MassiveRecord::Wrapper::TablesCollection.new
          collection.connection = self
          client.listTables.collect{|t| collection.push(Bytes.toString(t.getName()))}
          collection
        end
    
        def method_missing(method, *args)
          # TODO
        end
    
      end
    end
  end
end