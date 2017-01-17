class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :content
      t.references :conference, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
