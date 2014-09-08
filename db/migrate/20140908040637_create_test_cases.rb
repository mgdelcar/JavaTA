class CreateTestCases < ActiveRecord::Migration
  def change
    create_table :test_cases do |t|
      t.string :input
      t.string :output
      t.int :points
      t.int :max_time_execution_sec
      t.references :problem, index: true

      t.timestamps
    end
  end
end
