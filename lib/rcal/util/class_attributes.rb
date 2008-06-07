require 'rcal/util/extract_options'

unless Class.method_defined?(:cattr_accessor)
  class Class
    
    # Defines class- and instance-level readers for each class attribute
    # in +syms+.
    # If any of +syms+ is not yet defined, it is set to +nil+.
    #
    # Thanks, Rails!
    def cattr_reader(*syms)
      syms.flatten.each do |sym|
        next if sym.is_a?(Hash)
        class_eval(<<-EOS, __FILE__, __LINE__)
          unless defined? @@#{sym}
            @@#{sym} = nil
          end

          def self.#{sym}
            @@#{sym}
          end

          def #{sym}
            @@#{sym}
          end
        EOS
      end
    end
    
    # Defines class- and instance-level writers for each class attribute
    # in +syms+. If any of +syms+ is not yet defined, it is set to +nil+.
    #
    # If
    # <tt>syms.last.is_a?(Hash) && syms.last[:instance_writer] == false</tt>,
    # does _not_ declare an instance-level writer.
    #
    # Thanks, Rails!
    def cattr_writer(*syms)
      options = syms.extract_options!
      syms.flatten.each do |sym|
        class_eval(<<-EOS, __FILE__, __LINE__)
          unless defined? @@#{sym}
            @@#{sym} = nil
          end

          def self.#{sym}=(obj)
            @@#{sym} = obj
          end

          #{"
          def #{sym}=(obj)
            @@#{sym} = obj
          end
          " unless options[:instance_writer] == false }
        EOS
      end
    end
    
    # +cattr_reader+ and +cattr_writer+ in one.
    #
    # Thanks, Rails!
    def cattr_accessor(*syms)
      cattr_reader(*syms)
      cattr_writer(*syms)
    end
    
  end
end