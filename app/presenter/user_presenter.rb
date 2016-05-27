class UserPresenter < BasePresenter
  presents :user

  # TODO: this names have to change asap. because will cause data inconsistencies
  def rucom_number
    rucom_record
  end

  def name
    "#{ user.first_name } #{ user.last_name }"
  end

  # TODO: this have to change asap. because will cause data inconsistencies
  def company_name
    @object.company_name || self.name
  end

  # TODO: this have to change asap. because will cause data inconsistencies
  def nit
    @object.nit || self.document_number
  end

  # TODO: this have to change asap. because will cause data inconsistencies
  def city_name
    if has_office?
      office.city.name
    else
      city.name
    end
  end
end