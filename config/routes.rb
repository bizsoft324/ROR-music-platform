require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  root 'home#index'

  mount HumanPower::Rails::Engine => "robots.txt"
  mount Thredded::Engine => '/forum'
  scope constraints: CustomDomainConstraint.new do
    root  'artist_subdomains#show'
  end
  resources :home, only: [:index]

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  mount AudioUploader::UploadEndpoint, at: 'upload/audio'
  mount ImageUploader::UploadEndpoint, at: 'upload/image'

  resources :charts, only: :index
  resources :users

  resource :session, only: [:new, :create, :destroy] do
    get :profile, on: :member
    resource :sound_cloud, only: :show, controller: 'sessions/sound_cloud'
  end

  resources :password_resets, except: [:index, :show, :destroy]

  resource :profile,  only: [:show, :update]
  resource :waitlist, only: [:create, :update, :index]

  resources :soundbites, except: [:show]
  resources :battleground
  resources :notifications

  resources :comments do
    get 'usernames', on: :member
  end

  resources :artists do
    get :track_list
  end


  resources :beats, only: :index

  get '/auth/:provider/callback', to: 'sessions#callback', as: :auth_callbacks
  get '/signin', to: 'sessions#new'
  get '/signout', to: 'sessions#destroy'
  get '/signup', to: 'users#new'
  get '/waitlist', to: 'waitlists#index'
  get '/waitlist/:token/activate', to: 'waitlists#update'
  get '/waitlists/email_confirm'
  get '/waitlists/share'

  get '/invite/:referrer_id', to: 'waitlists#index', as: :invite_member

  resources :tracks do
    resources :comments
  end

  namespace :admin do
    get '/dashboards', to: 'dashboards#index'
    resources :sessions, only: [:new, :create]
    resources :users, only: [:index, :destroy]
    resources :critiques, only: [:index, :destroy]
    resources :tracks, only: [:index, :destroy]
    namespace :track do
      resources :charted, only: [:index, :destroy]
    end
  end



  #hide until fix import from soundcloud
  # get '/soundcloud' => 'sessions#soundcloud'
  # resources :soundcloud_tracks

  resources :critiques, only: :index
  resources :ratings, only: :index

  get 'critiques/:track_id' => 'critiques#show', as: :critique

  get '/sync' => 'tracks#sync'

  post 'beats/toggle_marked/:track_id' => 'tracks#update'
  get 'ratings/:track/:star' => 'ratings#create_or_update', as: :track_ratings

  get '/:id' => 'shortener/shortened_urls#show'
  get 'beats/:track_id/social_share' => 'beats#social_share', as: :social_share
  get 'beats/:track_id/track_info' => 'beats#track_info', as: :track_info

  get '/pages/:page' => 'pages#show'

  get '/update_player/:id' => 'tracks#update_player', as: :update_player

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV['SIDEKIQ_USER'] && password == ENV['SIDEKIQ_PASSWORD']
  end if Rails.env.production? || Rails.env.staging?

  mount Sidekiq::Web, at: '/sidekiq/dashboard'

end
