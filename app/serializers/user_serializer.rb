class UserSerializer < ActiveModel::Serializer
  attributes :id, :full_name

  def full_name
    "#{object.last_name} #{object.first_name}"
  end
end