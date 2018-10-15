require 'rails_helper'

RSpec.describe Admin::DashboardsController, type: :controller do
  describe '#index' do
    it 'responds correctly' do
      session[:admin] = true
      get 'index'
      response.should be_success
    end
  end
end
