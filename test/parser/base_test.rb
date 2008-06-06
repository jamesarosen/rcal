require File.join(File.dirname(__FILE__), '..', 'test_helper')
require 'rcal/parser/base'

class BaseParserTest < Test::Unit::TestCase
  include Rcal::Parser
  
  def test_initialize_with_nil_compliance_level
    assert_equal Rcal::Parser::default_compliance_level, Base.new.compliance_level
  end
  
  def test_initialize_with_valid_compliance_level
    assert_equal LAX, Base.new(LAX).compliance_level
  end
  
  def test_initialize_with_invalid_compliance_level
    assert_raises(ArgumentError) { Base.new('foo') }
  end
  
end