class AddTitleToTestCase < ActiveRecord::Migration
  def change
    add_column :test_cases, :title, :string
  end
end
