# frozen_string_literal: true

require 'aws-sdk-cognitoidentityprovider'
require 'cernight/reserved_attributes'

module Cernight
  class User
    extend Cognito

    attr_reader :username

    def initialize(username, attrs = [])
      @username = username
      @attrs = convert_attributes_to_hash(attrs)

      @attrs.keys.each do |key|
        define_singleton_method(key) { @attrs[key] }
        define_singleton_method("#{key}=") { |arg| @attrs[key] = arg }
      end
    end

    def save
      self.class.client.admin_update_user_attributes(
        user_pool_id: self.class.user_pool_id,
        username: @username,
        user_attributes: convert_attributes_to_array(@attrs)
      )
    end

    def update(args = {})
      update_params = (args.map do |key, value|
        key = "custom:#{key}" unless Cernight::RESERVED_ATTRIBUTES.include?(key.to_s)
        { name: key, value: value }
      end)

      self.class.client.admin_update_user_attributes(
        user_pool_id: self.class.user_pool_id,
        username: @username,
        user_attributes: update_params
      )
    end

    def convert_attributes_to_hash(array)
      array.inject({}) do |attrs, v|
        name = v[:name].include?('custom:') ? v[:name].gsub('custom:', '') : v[:name]
        attrs.merge(name => v[:value])
      end
    end

    def convert_attributes_to_array(hash)
      hash.delete('sub')
      hash.map { |v| { name: v[0], value: v[1] } }
    end

    Cernight::RESERVED_ATTRIBUTES.each do |attr|
      define_method(attr) { @attrs[attr] }
    end

    Cernight::RESERVED_ATTRIBUTES.each do |attr|
      define_method("#{attr}=") { |arg| @attrs[attr] = arg }
    end

    class << self
      attr_reader :user_pool_id, :client_id
    end

    def self.set_user_pool_id(id)
      @user_pool_id = id
    end

    def self.set_client_id(id)
      @client_id = id
    end

    def self.find_by_username(name)
      resp = client.list_users(
        user_pool_id: @user_pool_id,
        limit: 1,
        filter: "username = \"#{name}\""
      )

      user = resp.users.first
      new(user.username, user.attributes)
    end

    def self.create(username, password, attrs = {})
      user_attributes = (attrs.map do |key, value|
        key = "custom:#{key}" unless Cernight::RESERVED_ATTRIBUTES.include?(key.to_s)
        { name: key, value: value }
      end)

      resp = client.sign_up(
        client_id: client_id,
        username: username,
        password: password,
        user_attributes: user_attributes
      )
      find_by_sub(resp.user_sub)
    rescue Aws::CognitoIdentityProvider::Errors::ServiceError => e
      puts e
    end

    def self.find_by_sub(sub)
      resp = client.list_users(
        user_pool_id: @user_pool_id,
        limit: 1,
        filter: "sub = \"#{sub}\""
      )

      user = resp.users.first
      new(user.username, user.attributes)
    end

    def self.all
      resp = client.list_users(user_pool_id: @user_pool_id)
      resp.users.map { |user| new(user.username, user.attributes) }
    end
  end
end
