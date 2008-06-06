class Rcal::Parser::ParseError < StandardError
  
  attr_reader :ical, :parent
  
  # +ical+ and +parent+ are required.  +message+ is optional; a default
  # message is generated if none is provided.
  def initialize(ical, parent, message = nil)
    ical ||= 'nil'
    parent ||= 'nil'
    super(message || default_message(ical, parent))
    @ical, @parent = ical, parent
  end
  
  private
  
  def default_message(ical, parent)
    "#{ical} is not valid in context #{parent}"
  end
  
end