# == Schema Information
#
# Table name: follows
#
#  id                :integer          not null, primary key
#  following_user_id :integer
#  followed_user_id  :integer
#
class Follow < ActiveRecord::Base
  # TODO: validation

  belongs_to :following_user, class_name: 'User'
  belongs_to :followed_user, class_name: 'User'
end
