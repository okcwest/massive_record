module MassiveRecord
  def self.adapter=(name)
    @adapter = name
  end
  
  def self.adapter
    @adapter
  end
end

# Default adapter is set to thrift
MassiveRecord.adapter = defined?(JRUBY_VERSION) ? :native : :thrift

# Check the adapter is valid
raise "The adapter can only be 'thrift'." unless [:native, :thrift].include?(MassiveRecord.adapter)

# Load specific adapter
require "massive_record/adapters/#{MassiveRecord.adapter}/adapter"
