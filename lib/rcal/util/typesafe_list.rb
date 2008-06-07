require 'rcal/util'

# A typesafe list - that is, a list that allows only things of type T to be
# added.  T can be a class or module, and checks use <tt>kind_of?</tt>, so
# inherited classes work fine.
class Rcal::Util::TypesafeList
  include Rcal::Util
  include Enumerable
  
  attr_reader :klass
  attr_accessor :array
  
  protected :array, :array=
  
  # Create a new TypesafeList of type +klass+.
  #
  # Raises ArgumentError if +klass+ is not a class or module.
  def initialize(klass)
    raise ArgumentError.new("#{klass} is not a class or module") unless
      klass.kind_of?(Module)
    @klass = klass
    @array = []
  end
  
  # Empties the list.
  #
  # Returns +self+.
  def clear
    array.clear
    self
  end
  
  # Returns whether or not the list is empty.
  def empty?
    array.empty?
  end
  
  # Returns the list's length.
  def length
    array.length
  end
  
  alias_method :size, :length
  
  # Calls +block+ once for each element in +self+, passing that element as a
  # parameter.
  def each(&block)
    array.each(&block)
  end
  
  # Returns the first element in the list, or +nil+ if the list is empty.
  def first
    array.first
  end
  
  # Returns the last element in the list, or +nil+ if the list is empty.
  def last
    array.last
  end
  
  # Adds each of +objs+ to the end of the list.
  #
  # Returns +self+.
  #
  # Raises TypeError if any of +objs+ is not a +klass+.
  def push(*objs)
    check!(*objs)
    array.push(*objs)
    self
  end
  
  # Adds +obj+ to the end of the list.
  #
  # Returns +self+.
  #
  # Raises TypeError if +obs+ is not a +klass+.
  def <<(obj)
    check!(obj)
    array << obj
    self
  end
  
  # Adds +objs+ to the front of the list.
  #
  # Returns +self+.
  #
  # Raises TypeError if any of +objs+ is not a +klass+.
  def unshift(*objs)
    check!(*objs)
    array.unshift(*objs)
    self
  end
  
  # Concatenates self with +other+.  If +other+ is a TypesafeList of the same
  # type as this list, the result is also a TypesafeList of the same type.
  # Otherwise, the result is an Array.
  #
  # Returns a TypesafeList or Array.
  #
  # Raises ArgumentError if +other+ does not respond to +each+.
  def +(other)
    raise ArgumentError.new("Cannot concatenate a TypesafeList with #{other}") unless
      other.respond_to?(:each)
      
    if same_kind_as?(other)
      result = TypesafeList.new(klass)
      result.array = self.array.dup
    else
      result = self.to_a
    end
    
    other.each { |i| result << i }
    
    result
  end
  
  def to_a
    array.dup
  end
  
  def to_ical
    array.to_ical
  end
  
  def ==(other)
    same_kind_as?(other) && self.array == other.array
  end
  
  private
  
  # Raises TypeError if any of +objs+ is not a +klass+.
  def check!(*objs)
    objs.each do |o|
      raise TypeError.new("#{o} is not a #{klass}") unless o.kind_of?(klass)
    end
  end
  
  # Returns whether +other+ is a TypesafeList with the same +klass+ as this
  # list's.
  def same_kind_as?(other)
    other.kind_of?(TypesafeList) && other.klass == klass
  end
  
end
  
  
