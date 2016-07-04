class UserPresenter < BasePresenter
  presents :user

  # TODO: this names have to change asap. because will cause data inconsistencies
  def rucom_number
    rucom_record
  end

  def name
    "#{ user.profile.first_name } #{ user.profile.last_name }"
  end

  # TODO: this have to change asap. because will cause data inconsistencies
  def company_name
    @object.company_name || self.name
  end

  # TODO: this have to change asap. because will cause data inconsistencies
  def nit
    @object.profile.nit || self.profile.document_number
  end

  def document_type
    'NIT' # TODO: change this in the final document
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