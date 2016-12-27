namespace :fixes do
  desc "Allows match the purchase sellers with a user setting if it not exist yet.\
    This is applied to enable Running the Tax Module Report"
  task :purchase_sellers_and_user_setting => :environment do
    orders = Order.where(type: 'purchase')
    puts "Purchase to be processed: #{orders.size}"
    orders.each_with_index do |order, index|
      seller = order.seller
      unless seller.setting
        user_setting = FactoryGirl.create :user_setting, profile_id: seller.profile.id
        puts "(#{index} )-> user_setting_id: #{user_setting.id} regime_type: #{user_setting.regime_type}- order_id: #{order.id} - seller_id: #{seller.id} - profile_id: #{seller.profile.id}"
      end
    end
  end

  desc "TODO"
  task :not_defined_yet => :environment do
  end
end



