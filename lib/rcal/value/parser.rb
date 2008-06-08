require 'rcal/value'
require 'rcal/parser/base'

# A parser providing support for the value classes.
class Rcal::Value::Parser < Rcal::Parser::Base
  
  # Returns the value type that this parser parses as a String (e.g. 
  # 'BOOLEAN' or 'DATE-TIME').
  #
  # Subclasses *MUST* redefine this method.
  def value_type
    raise MethodNotImplemented('Subclasses MUST redefine value_type')
  end
  
end