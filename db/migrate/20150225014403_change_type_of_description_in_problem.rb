class ChangeTypeOfDescriptionInProblem < ActiveRecord::Migration
  def change
    change_column :problems, :description, :text
  end
end
