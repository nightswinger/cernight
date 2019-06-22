require 'aws-sdk-cognitoidentityprovider'

module Cernight::Cognito
  def client
    @client ||= Aws::CognitoIdentityProvider::Client.new(region: 'ap-northeast-1')
  end
end