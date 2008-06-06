unless [].respond_to?(:extract_options!)
  class ::Array
    
    # Extract options from a set of arguments. Removes and returns the last element in the array if it's a hash, otherwise returns a blank hash.
    #
    #   def options(*args)
    #     args.extract_options!
    #   end
    #
    #   options(1, 2)           # => {}
    #   options(1, 2, :a => :b) # => {:a=>:b}
    #
    # Thanks, ActiveSupport!
    def extract_options!
      last.is_a?(::Hash) ? pop : {}
    end
    
  end
end