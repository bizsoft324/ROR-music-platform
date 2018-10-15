class Subgenre < ActiveRecord::Base
  belongs_to :genre
  has_and_belongs_to_many :tracks
end
