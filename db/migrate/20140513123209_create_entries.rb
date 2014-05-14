class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.integer :category_id
      t.text :title
      t.datetime :start
      t.datetime :finish

      t.timestamps
    end
  end
end
