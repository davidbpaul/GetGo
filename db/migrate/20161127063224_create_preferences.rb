# class CreatePreferences
class CreatePreferences < ActiveRecord::Migration[5.0]
  def change
    create_table :preferences do |t|
      t.references :user, index: true, foreign_key: true
      t.string :route
      t.string :route_variant
      t.string :from_stop
      t.string :to_stop
      t.timestamps
    end
  end
end
