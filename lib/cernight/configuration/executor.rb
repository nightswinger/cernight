class Cernight::Configuration
  class Executor
    include Cernight::Cognito

    def initialize(method, params)
      @method = method
      @params = params
    end

    def run
      begin
        client.send(@method, @params)
      rescue Aws::CognitoIdentityProvider::Errors::InvalidParameterException => error
        puts error
      end
    end
  end
end