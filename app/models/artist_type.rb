class ArtistType < ActiveRecord::Base
  has_many :tracks
end
