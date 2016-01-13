class AddCaloriesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :calories, :integer, default: 2000
  end
end
