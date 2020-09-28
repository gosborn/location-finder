class V1::LocationsController < AuthorizedController
  before_action :set_location, only: [:show]

  def show
    render json: LocationSerializer.new(@location).serializable_hash
  end

  private

  def set_location
    @location = Location.find(params[:id])
  end
end
