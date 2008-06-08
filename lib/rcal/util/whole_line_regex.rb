class Regexp
  
  # Returns a new Regexp that is the same as this with both a start and an end anchor.
  def to_whole_line
    Regexp.new("^(?:#{self})$")
  end
  
end