class AddRepost < ActiveRecord::Migration[6.1]
  def change
    add_reference :posts, :repost, index: true
  end
end
