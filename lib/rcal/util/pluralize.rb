unless ''.respond_to?(:pluralize)
  class String
    # Trivial pluralization defined only if no other exists; adds 's' unless
    # the String already ends in 's'.
    def pluralize
      self[-1] == 's'[0] ? self.dup : "#{self}s"
    end
    
    # Trivial singularization defined only if no other exists; removes 's'
    # from the end of the String if it's there.
    def singularize
      self[-1] == 's'[0] ? self[0,self.length-1] : self.dup
    end
  end
end