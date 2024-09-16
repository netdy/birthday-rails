class LoginController < ApplicationController
  def index
  end

  def create
    user = User.find_by(username: params[:username])
    if user&.authenticate(params[:password])
      # Login success
      session[:user_id] = user.id
      redirect_to page_index_path
    else
      render turbo_stream: turbo_stream.update("error-messages", partial: "login/form_errors", locals: { errors: [ "Invalid user or password" ] })
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "Logged out!"
  end
end
