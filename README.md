FatSecret Gem
=============

Introduction
------------
An activemodel compliant wrapper to the FatSecret api. You need to register with FatSecret to get
a key and secret. At the moment only the food search, and get methods are implemented.  More methods
can be easily implemented.  See development for more information

Installation
------------
If you are using bundler, you put this in your Gemfile:

```ruby
source :rubygems
gem 'fatsecret-models', :git => 'https://github.com/joeyjoejoejr/Fatsecret.git'
```
Then run bundle install

or `gem install fatsecret-models`

Useage
------

Rails:

run `rails generate fatsecret::install`
this will create a `fatsecret.rb` initializer file in `config/initializers`
fill in your fatsecret key and secret.  Make sure to exclude this file from version control


Ruby:

You must set up configuration before instantiating any of the FatSecret classes:


```ruby
FatSecret.configure do |config|
  config.api_key = <your key>
  config.api_secret = <your secret key>
end
```  

`FatSecret::Connection` is a lightweight wrapper of the api and can be used alone.
It currently has a search, and a get method.  Both take three arguments and return a ruby hash.

```ruby
connection = FatSecret::Conection.new
connection.search(method, searchArguments, additionalArguments)
connection.get(method, ID, additionalArguments)
```
    
A real world example:

```ruby
connection = FatSecret::Connection.new
connection.search :food, "Apple", :max_results => "10"
connection.get :food, 12345
```

`FatSecret::Food` is an ActiveModel Compliant representation of the api data that
fits a number of useful rails model idioms.  Usage is simple.

```ruby
foodlist = FatSecret::Food.find_by_name("Apple") # returns an array of Food objects
first_food = foodlist.first.reload #returns a full food model from the api
first_food.servings.first #returns the first serving object
```
    
You can also instantiate and create your own food objects using mass assignment

```ruby
food = FatSecret::Food.new(:food_id => 12345, :food_name => "Bad and Plenties")
food.servings.new(:calories => "45", :vitamin_a => "millions of mgs")
food.servings_attributes = [{array => of}, {hashes => ""}]
```
    
See the `food_spec.rb` file for more examples

Development
-------------

Setup:

```    
git clone 'https://github.com/joeyjoejoejr/Fatsecret.git'
cd Fatsecret
git checkout 'active_model'
bundle install
```
    
You'll need to set up your api-key and api-secret in the `spec/support/set_keys` files
then run the specs

```
bundle exec rspec spec/
```
  
Please submit pull requests with fixes, updates, new models.

Setting up a new model


```ruby
# file "/lib/fatsecret.rb"
require "fatsecret/models/your_new_model.rb"
```    
Most of what you need is in the base class

```ruby
"lib/fatsecret/models/your_new_model"
module FatSecret
  class YourNewModel < FatSecret::Base
    #predefine attributes for validations, others will be created dynamically
    attribute :monkey, :type => String, :default => 'Oooh, ohh, Ahh'  
    
    validates :monkey, :presence => True
    
    #creates an instance of FatSecret::Relation so that mass assigment and  
    #"food_object.insects.new" will work.  You will need to create that related model.
    has_many :insects

    #this model has access to the connection object so you can define methods
    #this should all be customized to deal with how Fatsecret returns
    def self.find(id, args = {})
      attrs = connection.get(api_method, id.to_s, args)
      attrs['your_new_model']['insect_attributes'] = attrs['your_new_model']['insects']['insect']
      attrs['your_new_model'].delete 'insects'
      self.new attrs['your_new_model']
    end

    def self.find_by_name(name, args = {})
      results = connection.search(api_method, name, args)
     return_results = []
     results['your_new_models']['your_new_model'].each do |thing|
       return_results.push self.new thing
     end
     return_results
    end
  end

  class Insect < FatSecret::Base
  end
end
```    
