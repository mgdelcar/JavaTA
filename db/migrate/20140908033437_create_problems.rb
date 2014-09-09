class CreateProblems < ActiveRecord::Migration
  def change
    create_table :problems do |t|
      t.string :title
      t.string :description
      t.boolean :detect_plagiarism
      t.string :language

      t.timestamps
    end
  end
end
