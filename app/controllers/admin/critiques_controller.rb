class Admin::CritiquesController < AdminsController
  def index
    respond_to do |format|
      format.html
      format.json { render json: CritiqueDatatable.new(view_context) }
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy!
    redirect_to admin_critiques_path
  end
end
