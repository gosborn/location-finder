class TokenAuthority
  class << self
    def issue_token_to_user(user)
      JWT.encode(TokenPayload.new_for_user(user), token_secret)
    end

    def decode_from_request(request)
      auth_header = request.headers['Authorization']
      token = auth_header.split(' ').last
      decode_token(token)
    rescue
      TokenPayload.new
    end

    private

    def decode_token(token)
      TokenPayload.new(JWT.decode(token, token_secret).first)
    end

    def token_secret
      ENV.fetch('TOKEN_SECRET')
    end
  end
end
