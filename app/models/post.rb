# == Schema Information
#
# Table name: posts
#
#  id      :integer          not null, primary key
#  title   :text
#  content :text
#  user_id :integer
#
class Post < ActiveRecord::Base
  # TODO: validation

  belongs_to :user
  has_many :likes, as: :likable
end
