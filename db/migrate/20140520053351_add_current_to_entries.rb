class AddCurrentToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :current, :boolean
  end
end
