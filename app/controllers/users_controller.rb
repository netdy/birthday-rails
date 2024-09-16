class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    puts "------------------------- create user"
    @user = User.new(user_params)
    if @user.save
      redirect_to login_path, notice: "Account created successfully!"
    else
      error_messages = @user.errors.full_messages.to_sentence
      render turbo_stream: turbo_stream.update("error-messages", partial: "login/form_errors", locals: { errors: error_messages })
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
