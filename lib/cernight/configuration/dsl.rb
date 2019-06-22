class Cernight::Configuration
  class Dsl
    autoload :Common, 'cernight/configuration/common'

    include Cernight::Cognito
    include Common

    def initialize(pool_name, &block)
      @block  = block

      @params = { pool_name: pool_name }
      @schema_attributes = []
    end

    def evaluate
      return if @evaluated
      @block.call(self) if @block
      @evaluated = true
    end

    def params
      evaluate
      @params
    end
  end
end