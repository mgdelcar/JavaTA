class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :message
      t.integer :line_number
      t.references :source_file, index: true
      t.references :comment, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
