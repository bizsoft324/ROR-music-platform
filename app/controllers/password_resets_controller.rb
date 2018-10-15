class PasswordResetsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def new; end

  def create
    @user = User.find_by(email: params[:email])
    return @user.send_password_reset if @user
    @error = 'Please try again with other information'
    render :new
  end

  def update
    @user = User.find(params[:id])
    if @user.password_reset_sent_at && (@user.password_reset_sent_at < 12.hours.ago)
      redirect_to :root
    elsif @user.update_attributes!(user_params)
      redirect_to :root
    else
      render :edit
    end
  end

  def edit
    @user = User.find_by(password_reset_token: params[:password_reset_token])
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
