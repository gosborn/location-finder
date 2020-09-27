class TokenPayload
  attr_accessor :expires_at, :issuer, :user_id
  attr_writer :error

  VALIDATIONS = {
      issuer_incorrect?: 'Token invalid',
      expired?: 'Token expired',
  }

  def initialize(payload={})
    @expires_at = payload['expires_at']
    @issuer = payload['issuer']
    @user_id = payload['user_id']
  end

  def valid_user
    user if error.nil?
  end

  def error
    return @error unless @error.nil?
    validation_issue = VALIDATIONS.keys.find{|validation| send(validation)}
    @error ||= VALIDATIONS[validation_issue]
  end

  def self.new_for_user(user)
    self.token_defaults.merge!(user_id: user.id)
  end

  private
  def user
    User.find_by(id: user_id)
  end

  def issuer_incorrect?
    issuer.nil? || issuer != TokenPayload.token_issuer
  end

  def expired?
    expires_at.nil? || Time.at(expires_at) < Time.now
  end

  def self.token_issuer
    ENV.fetch('TOKEN_ISSUER')
  end

  def self.token_defaults
    {
        expires_at: 10.minutes.from_now.to_i,
        issuer: token_issuer
    }
  end
end
