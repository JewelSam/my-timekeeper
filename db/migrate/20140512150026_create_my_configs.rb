class CreateMyConfigs < ActiveRecord::Migration
  def change
    create_table :my_configs do |t|
      t.string :key
      t.string :key_ru
      t.text :value

      t.timestamps
    end
  end
end
