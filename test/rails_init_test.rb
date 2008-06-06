require File.join(File.dirname(__FILE__), 'test_helper')
require 'rcal/parser'
require 'rcal/util/loggable'

class RailsInitTest < Test::Unit::TestCase
  
  def setup
    unset_rails_env
  end
  
  def teardown
    unset_rails_env
  end
  
  def unset_rails_env
    if Object.const_defined?(:RAILS_ENV)
      Object.instance_eval { remove_const :RAILS_ENV }
    end
  end
  
  def set_rails_env(env)
    Object.instance_eval { const_set :RAILS_ENV, env }
  end
  
  def load_rails_init!
    # require will only do this once
    load File.join(File.dirname(__FILE__), '..', 'init.rb')
  end
  
  def test_sets_parser_default_compliance_level_to_strict_if_rails_env_is_development
    set_rails_env 'development'
    load_rails_init!
    assert_equal Rcal::Parser::STRICT, Rcal::Parser::default_compliance_level
  end
  
  def test_sets_parser_default_compliance_level_to_strict_if_rails_env_is_test
    set_rails_env 'test'
    load_rails_init!
    assert_equal Rcal::Parser::STRICT, Rcal::Parser::default_compliance_level
  end
  
  def test_sets_parser_default_compliance_level_to_lax_if_rails_env_is_production
    set_rails_env 'production'
    load_rails_init!
    assert_equal Rcal::Parser::LAX, Rcal::Parser::default_compliance_level
  end
  
  def test_sets_default_logger_level_to_debug_if_rails_env_is_development
    set_rails_env 'development'
    load_rails_init!
    assert_equal Logger::DEBUG, Rcal::Util::Loggable::default_logger.level
  end
  
  def test_sets_default_logger_level_to_debug_if_rails_env_is_test
    set_rails_env 'test'
    load_rails_init!
    assert_equal Logger::DEBUG, Rcal::Util::Loggable::default_logger.level
  end
  
  def test_sets_default_logger_level_to_error_if_rails_env_is_production
    set_rails_env 'production'
    load_rails_init!
    assert_equal Logger::ERROR, Rcal::Util::Loggable::default_logger.level
  end
  
end