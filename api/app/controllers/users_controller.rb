class UsersController < ApplicationController
  before_action :authenticate_request!, except: [:create, :login]

  def login
    user = User.find_by(email: user_params[:email].to_s.downcase)

    if user&.authenticate(user_params[:password])
      auth_token = TokenAuthority.issue_token_to_user(user)
      render json: { auth_token: auth_token }, status: :ok
    else
      render json: { error: 'Invalid username/password' }, status: :unauthorized
    end
  end

  def show
    render json: @current_user
  end

  def create
    @user = User.new(user_params)

    if @user.save
      auth_token = TokenAuthority.issue_token_to_user(@user)
      render json: { auth_token: auth_token }, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @current_user.destroy
  end

  private
    def user_params
      params.require(:user).permit(:email, :password)
    end
end
