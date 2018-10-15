class BeatsController < ApplicationController
  layout :false, only: :track_info

  before_action :track, only: %i[social_share track_info]

  def index
    page = 15
    @genres = Genre.all

    @tracks = filtered_tracks.beats_for_user(current_user).sorted_by_sort_name(params[:sort_by]).page(params[:page]).per(page)
  end

  private

  def track
    @track ||= Track.find(params[:track_id])
  end

  def filtered_tracks
    @filtered_tracks ||=
      if params[:filters]
        service = FilterService.new(filters: params[:filters])
        service.filtered
        @count = service.tracks.count unless params[:filters].except(:sort_by, :ratings).empty?
        service.tracks
      else
        return Track.includes(include_options) unless beats_search
        Track.includes(include_options).quick_search(params[:beats_search])
      end
  end

  def include_options
    [:by_week_chart, :critiques, :genres, :ratings, :subgenres, user: :badges]
  end

  def beats_search
    @beats_search ||= params[:beats_search] && params[:beats_search].strip.present?
  end
end
