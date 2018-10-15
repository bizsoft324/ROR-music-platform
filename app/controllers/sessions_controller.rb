class SessionsController < ApplicationController
  include SessionParams
  skip_before_filter :verify_authenticity_token

  def new
    @user_session = Session.new
  end

  def create
    @user_session = Session.new(params[:session])
    if @user_session.valid?
      sign_in(@user_session.user)
      @user_session.user.update_column(:last_activity_at, Time.now)

      SlackNotifierJob.perform_later(message: "User:  '#{@user_session.user.username}'  just  signed   in!")
      Tracker.track(@user_session.user.username, 'Logged in')
      ahoy.authenticate(@user_session.user)

      redirect_to beats_path
    else
      render :new
    end
  end

  def profile; end

  def destroy
    SlackNotifierJob.perform_later(message: t('.signed_out', username: current_user.username))
    reset_session
    cookies.delete :auth_token
    redirect_to root_url, notice: t('.success')
  end

  def callback
    return redirect_to root_path if params[:error]
    if authenticated?
      SoundCloudService.new(code: params[:code], redirect_uri: auth_callbacks_url(:soundcloud)).connect_account(current_user)
      redirect_to soundcloud_tracks_path
    else
      params[:provider] == 'twitter' ? twitter_callback : sound_callback
    end
  end

  private

  def sound_callback
    user = SoundCloudService.new(code: params[:code], redirect_uri: auth_callbacks_url(:soundcloud)).find_or_create_user
    sign_in(user)
    redirect_to new_track_path(profile: ('soundcloud' if user.invalid?))
  end

  def twitter_callback
    user = User.fetch_identity(twitter_identity_params, remove_empty_values(twitter_user_params))
    sign_in(user)
    redirect_to new_track_path(profile: ('twitter' if user.invalid?))
  end
end
