class ChangeInputAndOutputFormatInTestCases < ActiveRecord::Migration
  def change
    change_column :test_cases, :input, :text
    change_column :test_cases, :output, :text
  end
end
