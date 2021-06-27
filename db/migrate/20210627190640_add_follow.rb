class AddFollow< ActiveRecord::Migration[6.1]
  def change
    create_table :follows do |t|
      t.references :following_user, foreign_key: { to_table: :users }
      t.references :followed_user, foreign_key: { to_table: :users }
    end
  end
end
