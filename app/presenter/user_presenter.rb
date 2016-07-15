class UserPresenter < BasePresenter
  presents :user

  # TODO: this names have to change asap. because will cause data inconsistencies
  def rucom_number
    if has_office?
      company.rucom.rucom_record
    else
      rucom_record
    end
  end

  def provider_type
    user.rucom.provider_type
  end

  def name
    "#{ profile.first_name } #{ profile.last_name }"
  end

  # TODO: this have to change asap. because will cause data inconsistencies
  def company_name
    user.company_name || name
  end

  # TODO: this have to change asap. because will cause data inconsistencies
  def nit_number
    if has_office?
      company.nit_number
    else
      profile.nit_number
    end
  end

  def document_number
    profile.document_number
  end

  def document_type
    'NIT' # TODO: change this in the final document
  end

  def state_name
    profile.city.state.name
  end

  # TODO: this have to change asap. because will cause data inconsistencies
  def city_name
    if has_office?
      office.city.name
    else
      profile.city.name
    end
  end
end