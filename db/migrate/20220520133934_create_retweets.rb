class CreateRetweets < ActiveRecord::Migration[6.0]
  def change
    create_table :retweets do |t|
      t.bigint :post_id
      t.bigint :user_id

      t.timestamps
    end
  end
end
