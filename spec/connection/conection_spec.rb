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
    
    it "should reject an undefined method" do
      expect {@connection.search("notfood")}.to raise_error(TypeError)
    end
    
    #searches for different methods
    FatSecret.configure {}.api_methods.each do |method|
      it "should return a list of #{method}s for #{method} method", :vcr do
        results = @connection.search(method, "apple")
        results[method + 's'].should_not be_nil  
      end
    end
    
    it "should accept page_number and max_results arguments", :vcr do
      results = @connection.search("food", "apple", :max_results => "10", 
                                    :page_number => "5")
      results["foods"]["max_results"].should eq "10"
      results["foods"]["page_number"].should eq "5"
    end
    
    it "should return for no records found", :vcr do
      results = @connection.search("food","blablabla nmek123")
      results["foods"]["food"].should be_nil
    end
  end
  
  describe "get" do
    before(:each) do
      set_keys
      @connection = FatSecret::Connection.new()
    end
    
    it "should respond_to get" do
      @connection.should respond_to :get
    end
    
    it "should reject an undefined method" do
      expect {@connection.get("notfood", "99967")}.to raise_error(TypeError)
    end
    
    it "should return a food for food.get method", :vcr do
      results = @connection.get("food", "99967")
      results["food"].should_not be_nil  
    end
    
    it "should return a recipe for recipe.get method", :vcr do
      results = @connection.get("recipe", "30633")
      results["recipe"].should_not be_nil 
    end
  end
end
