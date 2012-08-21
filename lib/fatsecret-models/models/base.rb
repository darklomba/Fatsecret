require 'active_attr'

module FatSecret
  class Base
    include ActiveAttr::Model
    
    #Has many sets up the relationship methods needed to create new nested items
    #through mass assignment.  Use <class_symbol>_attributes to do so.
    def self.has_many(klass_sym)
      relation = FatSecret::Relation.new(sym_to_class(klass_sym))
      attribute klass_sym , :default => relation
      str = "#{klass_sym.to_s}_attributes="
      block = lambda do |args|
        args = [args] unless args.kind_of? Array
        args.each { |item| send(klass_sym).new(item) if send(klass_sym)}
      end
      send(:define_method, str.to_sym, &block)
    end
    
    #instance methods
    def initialize args = {}
      @dynattrs ||= {}
      super
      args.each do |k,v|
        #puts k.to_s + " : " + v.to_s
        send (k.to_s + "=").to_sym, v
      end
      
    end
    
    def method_missing sym, *args
      if sym =~ /^(\w+)=$/
        @dynattrs ||= {}
        @dynattrs[$1.to_sym]  = args[0]
      else
        @dynattrs[sym]
      end
    end
    
    def to_s
      str = super
      @dynattrs.merge(attributes).each do |k,v|
        #iv = iv.to_s.gsub(/@/, "")
        str = str.gsub(/[^=]>$/, " :#{k} => '#{v}' >")
      end      
      return str
    end
    
    def reload
      if self.class.respond_to? :api_method and self.class.respond_to? :find 
        find_id = send (self.class.api_method + "_id").to_sym
        self.class.find(find_id)
      else 
        self
      end
    end
    
    #Hack so that all the various sends aren't stuck in the protected space
    class << self
      protected :has_many
    end
    
    protected
      
      def self.connection
        @connection ||= FatSecret::Connection.new
      end
      
      def self.sym_to_class(klass_sym)
        klass = klass_sym.to_s.gsub(/s$/, "").split("_").map { |x| x.capitalize }.join
        FatSecret.const_get(klass)
      end
  end
end
