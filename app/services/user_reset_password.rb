class UserResetPassword
  attr_accessor :user

  def initialize(user)
    @user = user
  end

  def process!
    token = generate_reset_token
    save_reset_token(token)
    url = generate_url(token)
    send_email!(url)
  end

  private

  # Save the encoded token
  def  save_reset_token(token)
    enconded_token =  enconde_token(token)
    user.update_attribute(:reset_token,  enconded_token)
  end

  # @return [BCrypt::Password], used to match with the token sent to the user
  def get_reset_token
    BCrypt::Password.new(user.reset_token)
  end

  # @ return [String] that will be sent to the user
  def generate_reset_token
    Digest::MD5.hexdigest "#{user.updated_at}#{user.id}"
  end

  # @return [String], which will be saved in the DB and then will be compared with the token sent to the user
  def enconde_token(token)
    BCrypt::Password.create(token, :cost => 10)
  end

  # @return [String] with  the url that the user  will use to reset the password
  def generate_url(token)
    "#{host}/api/v1/auth/reset_password?token=#{token}"
  end

  def host
    'http://localhost:3000'
  end

  def send_email!(url)
    UserMailer.reset_password_email(user, url).deliver
  end
end