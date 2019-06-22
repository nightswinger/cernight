$:.unshift(File.expand_path("../", __FILE__))
module Cernight
  autoload :Configuration, 'cernight/configuration'
  autoload :Cognito,  'cernight/cognito'
end