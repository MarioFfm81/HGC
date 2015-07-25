class CreateTipps < ActiveRecord::Migration
  def change
    create_table :tipps do |t|
      t.references :user
      t.string :spiel
      t.integer :tipp1
      t.integer :tipp2
      t.timestamps null: false
    end
  end
end
