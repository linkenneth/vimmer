class Post < ActiveRecord::Base
  # TODO: validation

  belongs_to :user
  has_many :likes, as: :likable
end
