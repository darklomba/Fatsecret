require 'spec_helper'

describe FatSecret::Food do
  
  %w(food_id food_name food_id food_url servings).each do |food_attr|
    it "should respond to #{food_attr}" do
      FatSecret::Food.new.should respond_to food_attr  
    end
  end
  
  describe "validations" do
    before(:each) do
      @valid_attrs = { :food_name => "Blueberries", :food_id => "23", 
                      :food_url => "http://www.example.com/one-two-three"}
      @valid_serving = { :servings_attributes =>[{"calcium"=>"8", "calories"=>"200", 
                        "carbohydrate"=>"27", "cholesterol"=>"20", "fat"=>"10",
                        "fiber"=>"3", "iron"=>"2", "measurement_description"=>"serving",
                        "metric_serving_amount"=>"142.000", "metric_serving_unit"=>"g",
                        "number_of_units"=>"1.000", "protein"=>"4", "saturated_fat"=>"4",
                        "serving_description"=>"1 serving", "serving_id"=>"141998",
                        "serving_url"=>"http://www.fatsecret.com/calories-nutrition/au-bon-pain/apples-blue-cheese-and-cranberries",
                        "sodium"=>"290", "sugar"=>"20", "vitamin_a"=>"4", "vitamin_c"=>"8"},
                        {"calcium"=>"8", "calories"=>"500", 
                        "carbohydrate"=>"27", "cholesterol"=>"20", "fat"=>"10",
                        "fiber"=>"3", "iron"=>"2", "measurement_description"=>"serving",
                        "metric_serving_amount"=>"142.000", "metric_serving_unit"=>"g",
                        "number_of_units"=>"1.000", "protein"=>"4", "saturated_fat"=>"4",
                        "serving_description"=>"1 serving", "serving_id"=>"141998",
                        "serving_url"=>"http://www.fatsecret.com/calories-nutrition/au-bon-pain/apples-blue-cheese-and-cranberries",
                        "sodium"=>"290", "sugar"=>"20", "vitamin_a"=>"4", "vitamin_c"=>"8"}]
                        } 

    end
    
    it "should be valid with valid attributes" do
      food = FatSecret::Food.new(@valid_attrs)
      food.servings = @valid_serving[:servings_attributes]
      food.should be_valid 
    end
    
    it "should not be valid if not set", :vcr do
      FatSecret::Food.new.should_not be_valid
    end
    
    [:food_name, :food_id, :food_url].each do |model_attr|
      it "should not be valid without #{model_attr}" do
        food = FatSecret::Food.new(@valid_attrs.merge(model_attr => ""))  
        food.should_not be_valid
      end
    end
    
    it "should not be valid with a non-numerical food_id" do
      food = FatSecret::Food.new(@valid_attrs.merge(:food_id => "Monkey"))
      food.should_not be_valid
    end
    
    it "should accept nested attribures for servings" do
      valid = @valid_attrs.merge(@valid_serving) 
      food = FatSecret::Food.new(@valid_attrs) 
      food.should respond_to :servings
      food.servings_attributes = @valid_serving[:servings_attributes]
      food.servings.should_not be_empty
      food.servings.first.calcium.should eq '8'
    end
    
    it 'should directly accept nested attribues' do
      valid = @valid_attrs.merge(@valid_serving) 
      food = FatSecret::Food.new(valid) 
      food.should be_valid
      #puts food.servings.first
    end
  end
  
  describe "find" do
    
    before(:each) do
      set_keys
      @food = FatSecret::Food.find(99967)
    end
    
    it "should respond to find", :vcr do
      FatSecret::Food.should respond_to :find
    end
    
    it "should return something", :vcr do
      @food.should_not be_nil
    end
    
    it "should return a valid food model", :vcr do
      @food.should be_kind_of FatSecret::Food
      @food.should be_valid
      @food.servings.first.should be_kind_of FatSecret::Serving
    end
    
  end
  
  describe "find_by_name" do
    before(:each) do
      set_keys
      @food_list = FatSecret::Food.find_by_name("Apple")
    end
    
    it "should respond to find_by_name", :vcr do
      FatSecret::Food.should respond_to :find_by_name
    end
    
    it "should return an array", :vcr do
      @food_list.should_not be_nil
      @food_list.should be_kind_of Array
    end
    
    it "should be a list of food objects", :vcr do
      @food_list.first.should be_kind_of FatSecret::Food
      @food_list.first.should_not be_valid
    end
    
  end
  
  describe "reload" do
    it "should return a new model from the api", :vcr do
      food_list = FatSecret::Food.find_by_name("Apple")
      food = food_list.first
      food.should_not be_valid
      food.reload.should be_valid
    end
  end
  
end
