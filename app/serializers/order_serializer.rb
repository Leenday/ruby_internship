class OrderSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :tags, :name, :status, :cost

  def full_order
    "#{object.name} #{object.status} #{object.cost}"
  end
end
