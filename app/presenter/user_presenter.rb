class UserPresenter < BasePresenter
  presents :user

  # TODO: this  have to change asap. because will cause data inconsistencies
  # I am given the priority here just until we develop the new feature to buy as
  # a individual person or as a company. see GoldBatchBuyer service.
  def rucom_number
    office.company.rucom.rucom_record || rucom.num_rucom
  end

  def name
    "#{ user.first_name } #{ user.last_name }"
  end

  # TODO: this  have to change asap. because will cause data inconsistencies
  def city_name
    office.company.rucom.rucom_record || city.try(:name)
  end
end