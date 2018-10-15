class Badge < ActiveRecord::Base
  belongs_to :badge_duty, polymorphic: true
end
