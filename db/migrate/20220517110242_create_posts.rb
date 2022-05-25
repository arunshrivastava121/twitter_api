class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.bigint :user_id
      t.string :username
      t.text :text, null: false
      t.string :image_url
      t.boolean :verified, default: false

      t.timestamps
    end
  end
end
