class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :steps, :position
end