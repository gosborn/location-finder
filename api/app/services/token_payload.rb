class TokenPayload
  attr_accessor :expires_at, :issuer, :user_id
  attr_writer :error

  VALIDATIONS = {
    issuer_incorrect?: 'Token invalid'.freeze,
    expired?: 'Token expired'.freeze
  }.freeze

  def initialize(payload = {})
    @expires_at = payload['expires_at']
    @issuer = payload['issuer']
    @user_id = payload['user_id']
  end

  def valid_user
    user if error.nil?
  end

  def error
    return @error unless @error.nil?

    validation_issue = VALIDATIONS.keys.find { |validation| send(validation) }
    @error ||= VALIDATIONS[validation_issue]
  end

  private

  def user
    User.find(user_id)
  end

  def issuer_incorrect?
    issuer.nil? || issuer != TokenPayload.token_issuer
  end

  def expired?
    expires_at.nil? || Time.at(expires_at) < Time.now
  end

  class << self
    def new_for_user(user)
      token_defaults.merge!(user_id: user.id)
    end

    def token_issuer
      ENV.fetch('TOKEN_ISSUER')
    end

    private

    def token_defaults
      {
          expires_at: 10.minutes.from_now.to_i,
          issuer: token_issuer
      }
    end
  end
end
