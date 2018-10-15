class Admin::SessionsController < AdminsController
  skip_before_filter :verify_authenticity_token
  skip_before_action :require_admin

  def new
    @admin_session = Session.new
  end

  def create
    @admin_session = Session.new(params[:session])
    if @admin_session.valid? && @admin_session.user.roles == 'admin'
      session[:admin] = true
      redirect_to admin_dashboards_path
    else
      render :new
    end
  end
end
