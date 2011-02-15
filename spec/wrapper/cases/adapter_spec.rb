require 'spec_helper'

describe "The Massive Record adapter" do
  
  it "should default to thrift if Ruby is used" do
    MassiveRecord.adapter.should == (defined?(JRUBY_VERSION) ? :native : :thrift)
  end
  
  it "should default to native if JRuby is used" do
    MassiveRecord.adapter.should == (defined?(JRUBY_VERSION) ? :native : :thrift)
  end

end
