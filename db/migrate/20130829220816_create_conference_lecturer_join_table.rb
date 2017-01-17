class CreateConferenceLecturerJoinTable < ActiveRecord::Migration
  def change
    create_join_table :conferences, :lecturers do |t|
      # t.index [:conference_id, :lecturer_id]
      t.index [:lecturer_id, :conference_id], unique: true
    end
  end
end
