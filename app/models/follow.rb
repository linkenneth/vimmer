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

  belongs_to :following_user
  belongs_to :followed_user
end
