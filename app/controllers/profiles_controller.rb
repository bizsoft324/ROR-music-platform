class ProfilesController < ApplicationController
  before_action :authenticate!

  def show
    current_user.valid? if params[:invalid]
  end

  def update
    render :show unless current_user.update(profile_params)
  end

  def profile_params
    params.require(:user).permit(:avatar, :first_name, :last_name, :email, :description, :country,
                                 :username, :city, :password, :password_confirmation)
  end
end
