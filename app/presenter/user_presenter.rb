class UserPresenter < BasePresenter
  presents :user

  def rucom_number
    rucom.num_rucom || user.rucom.rucom_record
  end

  def name
    "#{ user.first_name } #{ user.last_name }"
  end

  def city_name
    city.name
  end
end