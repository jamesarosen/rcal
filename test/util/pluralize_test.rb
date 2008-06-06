require File.join(File.dirname(__FILE__), '..', 'test_helper')
require 'rcal/util/pluralize'

class PluralizeTest < Test::Unit::TestCase

  def test_pluralize_singular
    assert_equal 'boats', 'boat'.pluralize
  end
  
  def test_pluralize_plural
    assert_equal 'drinks', 'drinks'.pluralize
  end
  
  def test_singularize_singular
    assert_equal 'noun', 'noun'.singularize
  end
  
  def test_singularize_plural
    assert_equal 'noun', 'nouns'.singularize
  end
  
end