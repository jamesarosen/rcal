# :main:Rcal
# Rcal provides Ical parsing and generation in Ruby.
# It is built with the following in mind:
#
# == Follow the structure of Ical:
#   
# The Ical standard describes three distinct layers: Components,
# Properties, and Parameters.  These are mapped to modules
# (Component[link:/classes/Rcal/Component.html],
# Property[link:/classes/Rcal/Property.html],
# and Parameter[link:/class/rcal/Parameter.html]) in Rcal.
# Components, Proprerties, and Parameters are collectively called
# "parts" in this documentation (see Part[link:/classes/Rcal/Part.html]).
# All non-part classes in Rcal are "support."
#
# == Regularity of design:
#
# Each of the part classes has a <tt>parser(compliance_level)</tt> class
# method and a +to_ical+ instance method.  Each of the
# Component[link:/classes/Rcal/Component.html],
# Property[link:/classes/Rcal/Property.html],
# and Parameter[link:/classes/Rcal/Parameter.html] modules themselves has
# a <tt>parser(compliance_level)</tt> class method that returns a registry
# of all of the known individual parsers.  Users of the library can register
# additional parsers in these registries in order to add custom parts.
#
# == Real RFC-2445[link:/files/doc/RFC_2445_rdoc.html] Compliance:
#
# Rcal makes it hard (though not impossible) to generate
# non-compliant Ical content.  Many part classes are frozen, and most
# of the instances returned from parsing are immutable.  Those parts
# that are mutable will often raise exceptions (always noted in the rdoc)
# when improperly modified.
#
# A user of the library can always create a custom parser to generate
# mutable versions if absolutely necessary.
#
# == Parse modes:
#
# Parsing can be done in two modes: strict and lax.  These represent how
# problems are handled during parsing.  In strict mode, the following
# deviations from valid Ical raises an
# ParseError[link:/classes/Rcal/Parser/ParseError.html]:
#   
# * Parameter X inside a property that only allows parameters Y and Z
# * Parameter X not inside a property that requires at least one X
# * Property X inside a component that only allows properties Y and Z
# * No parser found for some Ical content (usually caused by improper
#   formatting)
# * A BEGIN:Vxxx without a matching END:Vxxx
# * Any deviation from a "MUST" or "MUST NOT" in RFC 2445
#
# In lax mode, the above deviations will cause an error to be logged,
# and the parser will return nil.
#
# In both modes, any deviations from "SHOULD" or "SHOULD NOT" will cause
# a warning to be logged.
#
# In general, strict is best used during testing and lax is best used for
# production.  For this reason, the library checks for RAILS_ENV and sets
# the default parse mode to strict if RAILS_ENV is 'development' or 'test',
# and to lax if it is 'production.'  If no RAILS_ENV is found, the default
# is strict.
#
# == Parsing and context-sensitivity:
#
# Much of the Ical spec is context-sensitive.  Certain values for the
# PARTSTAT parameter are valid only within certain components.  Certain
# properties can exist only in certain components.  A date-type property
# that doesn't end in 'Z' (for UTC) has a very different meaning depending
# on whether the property has a TZID parameter attached to it . . . and
# the TZID parameter itself refers to a VTIMEZONE - a completely separate
# component, found only by traveling up and then back down the component
# tree.  Because parsing is so context-sensitive, parsing methods take
# two arguments:
#   
# * ical: the actual text to be parsed
# * parent: the context in which it is parsed
#
# See Parser[link:/classes/Rcal/Parser.html] for more information on parsing.
module Rcal
end