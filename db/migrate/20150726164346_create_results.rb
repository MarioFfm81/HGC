class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.integer :year
      t.integer :matchday
      t.references :user
      t.float :result
      t.timestamps null: false
    end
  end
end
