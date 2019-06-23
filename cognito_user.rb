# frozen_string_literal: true

require_relative 'lib/cernight'

class User < Cernight::User
  set_user_pool_id 'ap-northeast-1_we4LNAsGD'
  set_client_id '16nuqqun1cq1e5382loahr1l1e'
end

user1 = User.find_by_username('testuser')
user2 = User.find_by_username('foobar')

p user2.nickname
user2.nickname = 'hey'
p user2.nickname
# user2.save
