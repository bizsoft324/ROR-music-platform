class ArtistSubdomain < ActiveRecord::Base
  belongs_to :user
  validates :slug, presence: true
  validates_uniqueness_of :slug
  before_create :normalize_slug

  def staging_hostname
    "#{slug}.beatthread.studio"
  end

  def production_hostname
    "#{slug}.beatthread.com"
  end

  if ENV['HEROKU_APP_NAME'] && ENV['HEROKU_OAUTH_TOKEN'] && Rails.env == 'staging'
    after_create do
      PlatformAPI.connect_oauth(ENV['HEROKU_OAUTH_TOKEN']).domain.create(ENV['HEROKU_APP_NAME'], hostname: staging_hostname)
    end

    after_destroy do
      PlatformAPI.connect_oauth(ENV['HEROKU_OAUTH_TOKEN']).domain.delete(ENV['HEROKU_APP_NAME'], staging_hostname)
    end
  end

  if ENV['HEROKU_APP_NAME'] && ENV['HEROKU_OAUTH_TOKEN'] && Rails.env == 'production'
    after_create do
      PlatformAPI.connect_oauth(ENV['HEROKU_OAUTH_TOKEN']).domain.create(ENV['HEROKU_APP_NAME'], hostname: production_hostname)
    end

    after_destroy do
      PlatformAPI.connect_oauth(ENV['HEROKU_OAUTH_TOKEN']).domain.delete(ENV['HEROKU_APP_NAME'], production_hostname)
    end
  end

  private

  def normalize_slug
    slug.downcase!
  end
end
