class ApplicationController < ActionController::API

  protected

  def authenticate_request!
    if !payload || !payload.is_valid?
      return invalid_authentication
    end

    load_current_user!
    invalid_authentication unless @current_user
  end

  def invalid_authentication
    render json: {error: 'Invalid Request'}, status: :unauthorized
  end

  private
  def payload
    @payload ||= get_payload_from_request
  end

  def get_payload_from_request
    auth_header = request.headers['Authorization']
    token = auth_header.split(' ').last
    TokenAuthority.decode_token(token)
  rescue
    nil
  end

  def load_current_user!
    @current_user ||= payload.user
  end
end

