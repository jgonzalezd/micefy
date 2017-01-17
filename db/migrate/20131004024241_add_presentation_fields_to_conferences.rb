class AddPresentationFieldsToConferences < ActiveRecord::Migration
  def change
    add_column :conferences, :status, :string
    add_column :conferences, :current_step, :integer, :default => 1
    add_column :conferences, :steps, :integer
  end
end
