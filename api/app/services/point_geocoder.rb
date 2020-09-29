class PointGeocoder

  def initialize(model, lat_column, lng_column, point_column)
    @model = model
    @lat_column = lat_column
    @lng_column = lng_column
    @point_column = point_column
  end

  def geocode_point
    return unless should_change_point_column && can_geocode_point
    @model[@point_column] = "POINT (#{@model[@lng_column]} #{@model[@lat_column]})"
  end

  private

  def should_change_point_column
    @model.send("#{@lat_column}_changed?") || @model.send("#{@lng_column}_changed?") || @model[@point_column].nil?
  end

  def can_geocode_point
    @model[@lat_column].present? && @model[@lng_column].present?
  end
end
