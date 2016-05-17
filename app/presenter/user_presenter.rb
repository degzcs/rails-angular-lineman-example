class UserPresenter < BasePresenter
  presents :user

  # TODO: this  have to change asap. because will cause data inconsistencies
  # I am given the priority here just until we develop the new feature to buy as
  # a individual person or as a company. see GoldBatchBuyer service.
  # TODO: this  have to change asap. because will cause data inconsistencies
  def rucom_number
    office.try(:company).try(:rucom).try(:rucom_record) || rucom.num_rucom
  end

  def name
    "#{ user.first_name } #{ user.last_name }"
  end

  # TODO: this  have to change asap. because will cause data inconsistencies
  def company_name
    @object.company_name || self.name
  end

  # TODO: this  have to change asap. because will cause data inconsistencies
  def nit
    @object.nit || self.document_number
  end

  # TODO: this  have to change asap. because will cause data inconsistencies
  def city_name
    office.try(:city).try(:name) || city.try(:name)
  end
end