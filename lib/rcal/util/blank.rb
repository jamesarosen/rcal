unless "".respond_to?(:blank?)
  
  class Object
    # Returns +false+.
    def blank?
      false
    end
  end

  class String
    # Returns +true+ iff +length+ returns 0.
    def blank?
      length == 0
    end
  end
  
  class NilClass
    # Returns +true+.
    def blank?
      true
    end
  end
  
end