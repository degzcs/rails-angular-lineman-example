class CreateRutActivities < ActiveRecord::Migration
  def change
    create_table :rut_activities do |t|
      t.string :code
      t.string :name
    end
  end
end
