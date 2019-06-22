module Cernight
  class Configuration
    autoload :Dsl,  'cernight/configuration/dsl'
    autoload :Executor, 'cernight/configuration/executor'

    def build
      puts "Should defined an build method for your configuration: #{self.class.name}"
    end

    def create_user_pool(name, &block)
      dsl = Dsl.new(name, &block)
      dsl.params
      executor = Executor.new(:create_user_pool, dsl.params)
      executor.run
    end
  end
end