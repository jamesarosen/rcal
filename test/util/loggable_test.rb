require File.join(File.dirname(__FILE__), '..', 'test_helper')
require 'rcal/util/loggable'

class LoggableTest < Test::Unit::TestCase
  include Rcal::Util
  
  class MyLoggable
    include Rcal::Util::Loggable
  end
  
  def setup
    @myloggable = MyLoggable.new
    
    @fatal = Logger.new(STDERR)
    @fatal.level = Logger::FATAL
  end
  
  def test_default_default_logger_level_is_debug
    assert_equal Logger::DEBUG, Loggable::default_logger.level
  end
  
  def test_set_default_logger_to_valid_logger
    Loggable::default_logger = @fatal
    assert_equal Logger::FATAL, Loggable::default_logger.level
  end
  
  def test_set_default_logger_to_nil_raises_error
    assert_raises(ArgumentError) { Loggable::default_logger = nil }
  end
  
  def test_set_default_logger_to_non_logger_raises_error
    assert_raises(ArgumentError) { Loggable::default_logger = 19 }
  end
  
  def test_instances_return_default_if_no_custom_set
    assert_equal Loggable::default_logger, @myloggable.logger
  end
  
  def test_custom_overrides_default
    @myloggable.logger = @fatal
    assert_equal @fatal, @myloggable.logger
  end
  
end