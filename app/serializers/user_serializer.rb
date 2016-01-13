class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :calories, :created_at, :updated_at, :auth_token

  has_many :meals
end
