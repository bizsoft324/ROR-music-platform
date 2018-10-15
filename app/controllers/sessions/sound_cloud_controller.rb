class Sessions::SoundCloudController < ApplicationController
  def show
    redirect_to SoundCloudService.new(redirect_uri: auth_callbacks_url(:soundcloud)).client.authorize_url
  end
end
