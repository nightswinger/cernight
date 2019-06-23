# frozen_string_literal: true

require_relative 'lib/cernight'

class User < Cernight::User
  set_user_pool_id 'ap-northeast-1_we4LNAsGD'
  set_client_id '16nuqqun1cq1e5382loahr1l1e'
end

user = User.find_by_username('testuser')
puts user.custom

users = User.all
puts users.first.username

u = User.create('tester', 'password', email: 'test@example.com')
puts u.username
