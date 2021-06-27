class AddBasicTables < ActiveRecord::Migration[6.1]
  def change
    # TODO: nullables and indices

    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :encrypted_password
    end

    create_table :posts do |t|
      t.text :title
      t.text :content

      t.references :user
    end

    create_table :likes do |t|
      t.references :likable, polymorphic: { default: 'Post' }
      t.references :user
    end
  end
end
