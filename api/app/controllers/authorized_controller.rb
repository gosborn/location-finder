class AuthorizedController < ApplicationController
  before_action :authenticate_request!
end