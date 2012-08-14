require 'spec_helper'

describe FatSecret::Connection do
  
  describe "Sting method" do
    it "should correctly format a sring" do
      "foo~bar baz".esc.should eq "foo~bar%20baz"
    end
  end
  
  describe "initialze" do
    it "should throw an error if api_keys aren't set" do
      expect {FatSecret::Connection.new()}.to raise_error(RuntimeError)
    end
  end
  
  describe "search" do
    before(:each) do
      set_keys
      @connection = FatSecret::Connection.new()
    end
    
    it "should respond_to search" do
      @connection.should respond_to :search
    end
  end
end
