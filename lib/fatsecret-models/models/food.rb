module FatSecret
  class Food < FatSecret::Base
    attribute :food_name, :type => String
    attribute :food_id, :type => Integer
    attribute :food_url, :type => String
    
    has_many :servings
    
    url_regex = /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/ 
    
    validates :food_name, :presence => true
    validates :food_id, :presence => true, :numericality => true
    validates :food_url, :presence => true, :format => { :with => url_regex }
    validate :has_serving
    
    #Instance Methods
    
    def self.find(id, args = {})
      attrs = connection.get(api_method, id.to_s, args)
      attrs['food']['servings_attributes'] = attrs['food']['servings']['serving']
      attrs['food'].delete 'servings'
      self.new attrs['food']
    end
    
    def self.find_by_name(name, args = {})
      results = connection.search(api_method, name, args)
      return_results = []
      if results && results['foods'] && results['foods']['food']
        results['foods']['food'].each do |food|
          return_results.push self.new food
        end
      end
      return_results
    end
    
    protected
      
      def self.api_method
        "food"
      end
      
      def has_serving
        errors.add(:base, 'must have one or more servings') if servings.empty?
      end
  end
end
