require 'logger'
require 'rcal/util'

# Simple logging support.
module Rcal::Util::Loggable
  
  # Returns the default logger.  Unless it has been set, this logs to
  # STDOUT, and is at level DEBUG.
  def self.default_logger
    @@default_logger ||= initialize_default_logger
  end
  
  # Sets the default logger.
  #
  # Returns +nil+.
  #
  # Raises ArgumentError unless +logger+ is a Logger.
  def self.default_logger=(logger)
    raise ArgumentError.new("#{logger} is not a Logger") unless logger.kind_of?(Logger)
    @@default_logger = logger
    nil
  end
  
  # Returns the custom logger if set, otherwise Rcal::Util::Loggable.default_logger.
  def logger
    @logger || Rcal::Util::Loggable.default_logger
  end
  
  # Sets a custom logger.
  #
  # Returns +nil+.
  #
  # Raises ArgumentError unless +logger+ is a Logger.
  def logger=(logger)
    raise ArgumentError.new("#{logger} is not a Logger") unless logger.kind_of?(Logger)
    @logger = logger
    nil
  end
  
  private
  
  def self.initialize_default_logger
    result = Logger.new(STDOUT)
    result.level = Logger::DEBUG
    result
  end
end