class AddDefaultCurrentStepToConferences < ActiveRecord::Migration
  def up
    change_column :conferences, :current_step, :integer, default: 1
    Conference.where(current_step: nil).update_all(current_step: 1)
  end

  def down
    change_column :conferences, :current_step, :integer, default: 1
  end
end
