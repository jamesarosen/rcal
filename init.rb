# File to make the project act like a Rails plugin.
#
# Sets Parser::default_compliance_level[link:/classes/Rcal/Parser.html]
# to strict if RAILS_ENV is 'development' or 'test,' and to lax if RAILS_ENV
# is 'production.'
#
# Sets
# Util::Loggable::default_logger.level[link:/classes/Rcal/Util/Loggable.html]
# to DEBUG if RAILS_ENV is 'development' or 'test,' and to ERROR if RAILS_ENV
# is 'production.'

if Object.const_defined?(:RAILS_ENV)
  require 'rcal/parser'
  require 'rcal/util/loggable'
  case RAILS_ENV
  when *['development', 'test']
    Rcal::Parser::default_compliance_level = Rcal::Parser::STRICT
    Rcal::Util::Loggable.default_logger.level = Logger::DEBUG
  when 'production'
    Rcal::Parser::default_compliance_level = Rcal::Parser::LAX
    Rcal::Util::Loggable.default_logger.level = Logger::ERROR
  end
end
    