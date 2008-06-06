Rcal is an Ical parser in Ruby.  It is built with the following in mind:

Parse Modes:
	Parsing can be done in two modes: strict and lax.
	When parsing in strict mode, any non-RFC-2445-compliant content will
	raise errors.
	When parsing in lax mode, any non-RFC-2445-compliant content will be
	logged, and either nil or [] will be returned as appropriate.