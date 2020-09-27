class ApplicationController < ActionController::API
  protected

  def authenticate_request!
    invalid_authentication unless current_user
  end

  def invalid_authentication
    render json: { error: payload.error }, status: :unauthorized
  end

  private

  def payload
    @payload ||= payload_from_request
  end

  def payload_from_request
    auth_header = request.headers['Authorization']
    token = auth_header.split(' ').last
    TokenAuthority.decode_token(token)
  rescue
    TokenPayload.new
  end

  def current_user
    @current_user ||= payload.valid_user
  end
end
