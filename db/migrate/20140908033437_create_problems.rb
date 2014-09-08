class CreateProblems < ActiveRecord::Migration
  def change
    create_table :problems do |t|
      t.string :title
      t.string :discription
      t.bool :detectPlagiarism
      t.string :language

      t.timestamps
    end
  end
end
