class Order < ApplicationRecord
    validates :name, length: { maximum: 10 }
    
    scope :high_cost, -> { where(cost: 1_000..) }
    scope :vip_failed, -> { failed.high_cost }
    scope :created_before, -> (time) { where('created_at < ?', time)}

    enum status: %w[unavailable created started failed removed]

    belongs_to :user
    has_and_belongs_to_many :tags
    # has_and_belongs_to_many :networks
end

# 10.times {|i| Order.create(name: "my_vm#{i}", cost: rand(1...1000))}