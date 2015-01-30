class CreateSourceFiles < ActiveRecord::Migration
  def change
    create_table :source_files do |t|
      t.string :relative_path
      t.text :source_code
      t.references :problem_submission, index: true

      t.timestamps
    end
  end
end
