# == Schema Information
#
# Table name: purchase_requests
#
#  id       :integer          not null, primary key
#  order_id :integer
#  buyer_id :integer
#

class PurchaseRequest < ActiveRecord::Base
  #
  # Associations
  #

  belongs_to :buyer, class_name: "User"
  belongs_to :order
end
