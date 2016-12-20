module CleanMethods
  # Allows remove all the registers if exist them
  def clean_user_profile_rucom_data(id_number)
    return false unless profile = Profile.find_by(document_number: id_number)
    user = profile.user
    rucom = user.rucom
    Profile.destroy(profile)
    Rucom.destroy(rucom) if rucom.present?
    User.destroy(user)
  end

  def clean_company_rucom_data(id_number)
    return false unless company = Company.find_by(nit_number: id_number)
    rucom = company.rucom
    Company.destroy(company)
    Rucom.destroy(rucom) if rucom.present?
  end
end