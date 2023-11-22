class CreateGroupUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :group_users do |t|
      t.references :user, foreign_key: true   #レファレンス型　indexがついて検索が早くなる。外部キー制約かけれる(rails ではアソシエーションを結んだ時点でバリデーションで止まるのでDBで止まるかバリデーションで止まるかの違いしかない)
      t.references :group, foreign_key: true
      t.timestamps
    end
  end
end
