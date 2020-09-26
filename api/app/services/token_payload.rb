class TokenPayload
  attr_accessor :expires_at, :issuer, :user_id

  def initialize(payload={})
    @expires_at = payload['expires_at']
    @issuer = payload['issuer']
    @user_id = payload['user_id']
  end

  def is_valid?
    not_expired? && matches_issuer?
  end

  def user
    User.find_by(id: user_id)
  end

  def self.new_for_user(user)
    self.token_defaults.merge!(user_id: user.id)
  end

  def self.token_defaults
    {
        expires_at: 10.minutes.from_now.to_i,
        issuer: token_issuer
    }
  end

  private
  def not_expired?
    expires_at && Time.at(expires_at) < Time.now
  end

  def matches_issuer?
    issuer == TokenPayload.token_issuer
  end

  def self.token_issuer
    ENV.fetch('TOKEN_ISSUER')
  end
end
