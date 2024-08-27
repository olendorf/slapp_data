class CreateRezzableServers < ActiveRecord::Migration[7.2]
  def change
    create_table :rezzable_servers do |t|
      t.timestamps
    end
  end
end
