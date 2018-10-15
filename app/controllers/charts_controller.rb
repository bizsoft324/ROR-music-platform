class ChartsController < ApplicationController
  def index
    @page = 25
    @tracks = Track.charted_by_period(params[:period]).page(params[:page]).per(@page)
    @tracks = @tracks.reverse_order.page(params[:page]).per(@page) if params[:direction] == 'asc'
  end
end
