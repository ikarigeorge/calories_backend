class CreateMeals < ActiveRecord::Migration
  def change
    create_table :meals do |t|
      t.string :name
      t.date :date
      t.time :time
      t.integer :calories
      t.integer :user_id

      t.timestamps null: false
    end
    add_index :meals, :user_id
  end
end
