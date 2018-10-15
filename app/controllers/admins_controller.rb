class AdminsController < ApplicationController
  layout 'admin'
  before_action :require_admin
end
