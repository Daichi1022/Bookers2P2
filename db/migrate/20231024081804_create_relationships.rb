class CreateRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :relationships do |t|
      t.integer :follower_id # フォローするユーザ-
      t.integer :followed_id # フォローされるユーザ-
      t.timestamps
    end
  end
end
