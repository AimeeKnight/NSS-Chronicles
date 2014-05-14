class CreateProject < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.string :language
      t.string :github_url
      t.string :hosted_url
      t.integer :student_id
      t.timestamps
    end
  end
end

