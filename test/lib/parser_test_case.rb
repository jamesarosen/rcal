require 'rcal/parser'
require 'rcal/parser/parse_error'

module ParserTestCase
  include Rcal::Parser
  
  attr_accessor :parser, :context
  
  def with_compliance_level(level, &block)
    old_level = parser.compliance_level
    parser.compliance_level = level
    block.call
    parser.compliance_level = old_level
  end
  
  def parse(value)
    parser.parse(value, context)
  end
  
  def is_parser_for?(value)
    parser.is_parser_for?(value)
  end
  
  def assert_is_parser_for(*values)
    values.each do |v|
      assert is_parser_for?(v)
    end
  end
  
  def assert_is_wrong_parser_for(*values)
    values.each do |v|
      assert !is_parser_for?(v)
    end
    assert_cannot_parse(*values)
  end
  
  def assert_parses(*values)
    values.each do |v|
      assert is_parser_for?(v), "Should be able to parse #{v}" + (context.nil? ? '' : " in context #{context}")
      with_compliance_level(STRICT) do
        assert_nothing_raised do
          param = parse(v)
          # TODO: implement .to_ical
          # assert_equal v, param.to_ical
        end
      end
    end
  end
  
  def assert_cannot_parse(*values)
    values.each do |v|
      with_compliance_level(STRICT) do
        assert_raises(ParseError) { parse(v) }
      end
      with_compliance_level(LAX) do
        assert_nil parse(v)
      end
    end
  end
  
end