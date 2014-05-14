class CreateStudent < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :first_name
      t.string :last_name
      t.integer :cohort_id
      t.boolean :alumni, default: false
      t.timestamps
    end
  end
end
