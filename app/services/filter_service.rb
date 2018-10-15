class FilterService
  attr_reader :filters, :tracks

  def initialize(attr = {})
    @filters = attr[:filters]
    @tracks = Track.includes(:by_week_chart).eager_load(:user, :critiques, :genres, :subgenres).all
  end

  def filtered
    filters.each do |k, v|
      @tracks = tracks.send(k, v)
    end
  end
end
