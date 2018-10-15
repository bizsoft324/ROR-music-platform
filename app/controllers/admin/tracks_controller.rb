class Admin::TracksController < AdminsController
  def index
    respond_to do |format|
      format.html
      format.json { render json: TrackDatatable.new(view_context) }
    end
  end

  def destroy
    @track = Track.find(params[:id])
    @track.destroy!
    redirect_to admin_tracks_path
  end
end
