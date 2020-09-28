class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :email, :created_at
end
