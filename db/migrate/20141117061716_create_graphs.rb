class CreateGraphs < ActiveRecord::Migration
  def change
    create_table :graphs do |t|
      t.integer :item_id
      t.string :name
      t.text :data

      t.timestamps
    end
  end
end
