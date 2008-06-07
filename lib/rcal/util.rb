require 'rcal'

# Various utility classes used throughout Rcal.  Many are taken from Rails,
# and are not reloaded if Rails has already done so.
#
# Modifies the following classes:
# * Object[link:/classes/Object.html]
# * Array[link:/classes/Array.html]
# * Date[link:/classes/Date.html]
# * DateTime[link:/classes/DateTime.html]
# * NilClass[link:/classes/NilClass.html]
# * Numeric[link:/classes/Numeric.html]
# * String[link:/classes/String.html]
# * Symbol[link:/classes/Symbol.html]
# * Time[link:/classes/Time.html]
# * URI::Generic[link:/classes/URI/Generic.html]
module Rcal::Util
end

require 'rcal/util/extract_options'
require 'rcal/util/to_ical'
require 'rcal/util/pluralize'
require 'rcal/util/loggable'
require 'rcal/util/typesafe_list'
require 'rcal/util/blank'