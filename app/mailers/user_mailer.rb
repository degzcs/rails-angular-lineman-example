class UserMailer < ActionMailer::Base
  default from: "trazoro-admin@trazoro.com"

  def reset_password_email(user, url)
    @user = user
    @url = url
    mail(to: user.email,subject: "Trazoro: Restablecer contrasena")
  end
end
