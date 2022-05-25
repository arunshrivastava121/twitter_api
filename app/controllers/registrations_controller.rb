class RegistrationsController < ApplicationController
  def create
    user = User.new(user_params)

    if user.save
      session[:user_id] = user.id
      render json: {
        user: user,
        status: :created
      }
    else
      render json: {
        user: user.errors
      }, status: 422
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end