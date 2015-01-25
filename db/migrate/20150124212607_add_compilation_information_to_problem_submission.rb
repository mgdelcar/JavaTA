class AddCompilationInformationToProblemSubmission < ActiveRecord::Migration
  def change
    add_column :problem_submissions, :compilation_result, :integer
    add_column :problem_submissions, :compiler_stdout, :text
    add_column :problem_submissions, :compiler_stderr, :text
    add_column :problem_submissions, :compiler_return_value, :integer
  end
end
