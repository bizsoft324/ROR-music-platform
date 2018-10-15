class HomeController < ApplicationController
  before_filter :user_logged_in

  def index
    @period = 'by_all_time_charts'
    @tracks = Track.charted_by_period(@period).limit(5)
  end
  protected

  def user_logged_in
    redirect_to(beats_path) && return if current_user
  end
end
