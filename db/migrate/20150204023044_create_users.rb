class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.string :last_name
      t.integer :user_type

      t.timestamps
    end
  end
end
