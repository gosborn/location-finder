class ApplicationController < ActionController::API
  protected

  def authenticate_request!
    invalid_authentication unless current_user
  end

  def invalid_authentication
    render json: { error: token_payload.error }, status: :unauthorized
  end

  private

  def token_payload
    @payload ||= TokenAuthority.decode_from_request request
  end
  
  def current_user
    @current_user ||= token_payload.valid_user
  end
end
