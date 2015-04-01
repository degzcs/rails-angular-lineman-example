class AddReffToCompanyInfo < ActiveRecord::Migration
  def change
    add_reference :company_infos, :provider
  end
end
