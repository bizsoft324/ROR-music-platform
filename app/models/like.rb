class Like < ActiveRecord::Base
  has_many :ratings
  has_many :tracks, through: :ratings
end
