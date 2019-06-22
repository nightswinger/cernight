class Cernight::Configuration::Dsl
  module Common
    attr_accessor(
      :minimum_length,
      :require_uppercase,
      :require_lowercase,
      :require_numbers,
      :require_symbols
      )

    def password_policy(&block)
      block.call(self)
      policies = {
        minimum_length: @minimum_length,
        require_uppercase: @require_uppercase,
        require_lowercase: @require_lowercase,
        require_numbers: @require_numbers,
        require_symbols: @require_symbols
      }

      @params[:policies]= { password_policy: policies }
    end

    def auto_verified_attributes(*args)
      @params[:auto_verified_attributes] = args.flatten
    end

    def email_configuration(args)
      return unless args.is_a?(Hash)
      @params[:email_configuration] = args
    end

    def schema(action=:create, &block)
      block.call(self)
      @params[:schema] = @schema_attributes
    end

    def string(name, opt={})
      params = {
        name: name,
        attribute_data_type: 'String'
      }
      @schema_attributes << params.merge(opt)
    end
  end
end