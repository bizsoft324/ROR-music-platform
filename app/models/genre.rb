class Genre < ActiveRecord::Base
  has_many :subgenres
  has_and_belongs_to_many :tracks
end
