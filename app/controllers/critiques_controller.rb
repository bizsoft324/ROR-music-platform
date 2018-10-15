class CritiquesController < ApplicationController
  protect_from_forgery except: :show
  before_action :authenticate!, only: :index

  def index
    @given_comments = current_user.track_comments.eager_load(:user).eager_load(critique: [:track]).send_order(params[:sort])
    @received_comments = current_user.critiques_comments.send_order(params[:sort])
  end

  def show
    @track = Track.eager_load(:user).find_by(id: params[:track_id])
    if @track.present?
      @comments = @track.root_comments.eager_load(:user).send_order(params[:sort])
    else
      no_track_redirect
    end
  end

  private

  def no_track_redirect
    redirect_to :back
  rescue ActionController::RedirectBackError
    redirect_to root_path
    flash[:danger] = 'Error! Cannot leave critique on nonexistent Track. Try again!'
  end
end
