require 'rcal/value/uri'

class Rcal::Value::CalAddressParser < Rcal::Value::UriParser
  
  # Returns 'CAL-ADDRESS'.
  def value_type
    'CAL-ADDRESS'
  end
  
end