# ApplicationController Class
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  skip_before_action :verify_authenticity_token

  def login
    render json: { message: 'logging in!' }
  end

  def logout
    render json: { message: 'logging out!' }
  end

  def authenticated_user
    if current_admin_user # current_user
      current_admin_user
    else
      false
    end
  end
end
