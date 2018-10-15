class Critique < ActiveRecord::Base
  belongs_to :track, counter_cache: true, touch: true
  has_many :comments, dependent: :destroy
  has_many :soundbites
end
