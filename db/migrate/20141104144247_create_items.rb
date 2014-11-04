class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name, :null=>false
      t.text :c1
      t.text :c2
      t.text :c3
      t.text :c4
      t.text :c5

      t.timestamps
    end
  end
end
