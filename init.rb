# File to make the project act like a Rails plugin.
# Sets Parser::default_compliance_level[link:/classes/Rcal/Parser.html]
# to strict if RAILS_ENV is 'development' or 'test,' and to lax if RAILS_ENV
# is 'production.'

if Object.const_defined?(RAILS_ENV)
  require 'rcal/parser'
  case RAILS_ENV
  when *['development', 'test']
    Rcal::Parser::default_compliance_level = Rcal::Parser::STRICT
  when 'production'
    Rcal::Parser::default_compliance_level = Rcal::Parser::LAX
  end
end
    