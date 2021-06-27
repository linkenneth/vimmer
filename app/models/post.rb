# == Schema Information
#
# Table name: posts
#
#  id        :integer          not null, primary key
#  title     :text
#  content   :text
#  user_id   :integer
#  repost_id :integer
#
class Post < ActiveRecord::Base
  # TODO: validation

  belongs_to :user
  has_many :likes, as: :likable

  has_one :repost, class_name: 'Post', foreign_key: :id, primary_key: :repost_id
end
