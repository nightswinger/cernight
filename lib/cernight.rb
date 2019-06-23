# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path(__dir__))
module Cernight
  autoload :Configuration, 'cernight/configuration'
  autoload :Cognito, 'cernight/cognito'
  autoload :User, 'cernight/user'
end
