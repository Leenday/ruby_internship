class Order < ApplicationRecord
    belongs_to :user
    has_and_belongs_to_many :tags
end

# 10.times {|i| Order.create(name: "my_vm#{i}", cost: rand(1...1000))}