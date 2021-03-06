class V1::VisitsController < AuthorizedController
  before_action :set_visit, only: [:show]

  def index
    render json: visits
  end

  def show
    render json: @visit
  end

  def create
    params = visit_params.merge user: @current_user
    @visit = Visit.new(params)

    if @visit.save
      render json: @visit, status: :created
    else
      render json: @visit.errors, status: :unprocessable_entity
    end
  end

  private

  def visits
    @visits ||= @current_user.visits
  end

  def set_visit
    @visit = Visit.find_by(id: params[:id], user_id: @current_user.id)
  end

  def visit_params
    params.require(:visit).permit(:description, :latitude, :longitude, :location_id)
  end
end
