class UsersController < ApplicationController
  include SessionParams
  before_action :find_user, only: %i[edit update]
  skip_before_filter :verify_authenticity_token

  def index; end

  def new
    @user = User.new
  end

  def create
    @agree = params[:agree]
    @user = User.new(user_params)
    render :new unless @user.save
    sign_in(@user)
  end

  def edit
    @user&.confirm!
    redirect_to new_track_path
    flash[:success] = 'Successfully confirmed email! You may now upload tracks.'
  end

  def update
    if params[:provider].present?
      @user.update(user_params)
      @avatar_data = params[:user][:avatar]
    elsif @user.update(user_params)
      redirect_to home_path
    else
      render :edit
    end
  end

  private

  def find_user
    @user = current_user || User.find(user_verifier[:id])
  end

  def user_params
    params.require(:user).permit(:avatar, :first_name, :last_name, :email, :country,
                                 :username, :city, :password, :password_confirmation)
  end

  def user_verifier
    verifier.verify(params[:token])
  end
end
