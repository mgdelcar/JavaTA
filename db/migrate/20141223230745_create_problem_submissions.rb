class CreateProblemSubmissions < ActiveRecord::Migration
  def change
    create_table :problem_submissions do |t|
      t.string :file_relative_path
      t.integer :iteration
      t.datetime :when
      t.references :problem, index: true

      t.timestamps
    end
  end
end
