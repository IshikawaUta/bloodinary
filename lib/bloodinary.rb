# Suppress parser version warning
$VERBOSE, old_verbose = nil, $VERBOSE
require 'parser/current'
$VERBOSE = old_verbose

require 'find'
require 'rainbow'
require 'json'

# Core
require_relative 'bloodinary/scanner'
require_relative 'bloodinary/processor'
require_relative 'bloodinary/reporter'

# Rules
require_relative 'bloodinary/rules/base_rule'
require_relative 'bloodinary/rules/sql_injection'
require_relative 'bloodinary/rules/xss_vulnerability'
require_relative 'bloodinary/rules/command_injection'
require_relative 'bloodinary/rules/file_access'
require_relative 'bloodinary/rules/insecure_redirect'
require_relative 'bloodinary/rules/weak_crypto'

module Bloodinary
  VERSION = "1.0.0"
end
