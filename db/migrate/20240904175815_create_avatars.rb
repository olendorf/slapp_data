class CreateAvatars < ActiveRecord::Migration[7.2]
  def change
    create_table :avatars do |t|
      t.string :avatar_name
      t.string :avatar_key
      t.string :display_name
      t.datetime :rezday

      t.timestamps
    end
  end
end
