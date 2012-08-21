module FatSecret
  class Relation < Array
    def initialize(klass)
      @klass = klass
      @models = []  
    end
    
    def new(args = {})
      push @klass.new(args)
      last
    end
  end
end
