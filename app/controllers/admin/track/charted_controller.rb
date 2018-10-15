class Admin::Track::ChartedController < AdminsController
  def index
    respond_to do |format|
      format.html
      format.json { render json: Track::ChartedDatatable.new(view_context) }
    end
  end

  def destroy
    @track_charted = Track::Charted.find(params[:id])
    @track_charted.destroy!
    redirect_to admin_tracks_charted_path
  end
end
