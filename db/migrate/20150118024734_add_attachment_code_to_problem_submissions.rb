class AddAttachmentCodeToProblemSubmissions < ActiveRecord::Migration
  def self.up
    change_table :problem_submissions do |t|
      t.attachment :code
    end
    remove_column :problem_submissions, :file_relative_path, :string
  end

  def self.down
    remove_attachment :problem_submissions, :code
    add_column :problem_submissions, :file_relative_path, :string
  end
end
