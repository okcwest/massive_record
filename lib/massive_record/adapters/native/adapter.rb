module MassiveRecord
  module Adapters
    module Native
    end
  end
end

ADAPTER = MassiveRecord::Adapters::Native

# Requirements
include Java

# HBase Java files
Dir["#{File.dirname(__FILE__)}/hbase/*.jar"].sort.each{|file| require file}

# Classes needed for the Adapter
java_import org.apache.hadoop.hbase.HBaseConfiguration
java_import org.apache.hadoop.hbase.MasterNotRunningException
java_import org.apache.hadoop.hbase.ZooKeeperConnectionException
java_import org.apache.hadoop.hbase.HColumnDescriptor
java_import org.apache.hadoop.hbase.HConstants
java_import org.apache.hadoop.hbase.HTableDescriptor
java_import org.apache.hadoop.hbase.client.HBaseAdmin
java_import org.apache.hadoop.hbase.client.HTable
java_import org.apache.hadoop.hbase.client.Get
java_import org.apache.hadoop.io.Text
java_import org.apache.hadoop.hbase.util.Bytes
java_import org.apache.hadoop.hbase.client.Put

# Adapter
require 'massive_record/adapters/native/connection'