class Soundbite < ActiveRecord::Base
  belongs_to :comment, dependent: :destroy
  belongs_to :critique, dependent: :destroy

  validates :data_start, :data_end, :title, presence: true
end
