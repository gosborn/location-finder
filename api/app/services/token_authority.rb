class TokenAuthority

  def self.issue_token_to_user(user)
    JWT.encode(TokenPayload.new_for_user(user), secret)
  end

  def self.decode_token(token)
    TokenPayload.new(JWT.decode(token, token_secret).first)
  rescue
    TokenPayload.new
  end

  private
  def self.token_secret
    ENV.fetch('TOKEN_SECRET')
  end
end
