class CreateCohort < ActiveRecord::Migration
  def change
    create_table :cohorts do |t|
      t.string :title
      t.string :languages
      t.string :term
      t.timestamps
    end
  end
end

