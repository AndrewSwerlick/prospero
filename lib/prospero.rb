require "prospero/version"
require 'bundler/setup'
require 'reform'

module Prospero
  autoload :Wizard, 'prospero/wizard'
  autoload :Form, 'prospero/form'
  autoload :Persistence, 'prospero/persistence'
  autoload :ModelName, 'prospero/model_name'
end
