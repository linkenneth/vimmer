# == Schema Information
#
# Table name: likes
#
#  id           :integer          not null, primary key
#  likable_type :string           default("Post")
#  likable_id   :integer
#  user_id      :integer
#
class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :likable, polymorphic: true

  scope :on_posts, -> { where(likable_type: 'Post') }
end
