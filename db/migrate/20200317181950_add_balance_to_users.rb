class AddBalanceToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :ballance, :integer
  end
end
