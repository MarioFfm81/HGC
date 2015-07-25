class UpdateTippTable < ActiveRecord::Migration
  def change
    change_column :tipps, :spiel, :integer
  end
end
