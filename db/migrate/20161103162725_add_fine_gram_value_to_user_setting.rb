class AddFineGramValueToUserSetting < ActiveRecord::Migration
  def change
    add_column :user_settings, :fine_gram_value, :float
  end
end
