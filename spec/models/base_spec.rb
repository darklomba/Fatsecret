require 'spec_helper'
require 'active_attr/mass_assignment'


describe FatSecret::Base do
  it_should_behave_like "ActiveModel"
  
  it "should not respond to save or create" do
    FatSecret::Base.new.should_not respond_to :save
    FatSecret::Base.new.should_not respond_to :save!
    FatSecret::Base.new.should_not respond_to :create
    FatSecret::Base.new.should_not respond_to :create!
  end
  
  describe "has_many" do
    before(:each) do
      class FatSecret::HasManyTest
        include ActiveAttr::MassAssignment
        attr_accessor :first_name, :last_name
      end
      
      class TestClass < FatSecret::Base
        has_many :has_many_tests
      end
      
      @testclass = TestClass.new
    end
    
    it "should create an accessible attribute based on the class class"  do
      @testclass.should respond_to :has_many_tests    
    end
    
    it "should return an array" do
      @testclass.has_many_tests.should be_kind_of Array
    end
    
    it "should create a new instance of the class and add it to the array" do
      @testclass.has_many_tests.new
      @testclass.has_many_tests.first.should be_kind_of FatSecret::HasManyTest
    end
    
    it "should destroy an associated record" do
      @testclass.has_many_tests.new
      @to_remove = @testclass.has_many_tests.first
      @testclass.has_many_tests.delete(@to_remove)
      @testclass.has_many_tests.should be_empty
    end
    
    it "should accept nested attributes" do
      @testclass.has_many_tests_attributes = {:first_name => "Joe", 
                                               :last_name => "Everyman"}
      @testclass.has_many_tests.first.first_name.should eq "Joe"
      @testclass.has_many_tests.first.last_name.should eq "Everyman"
    end
  end
end
