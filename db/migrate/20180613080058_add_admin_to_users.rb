#rails generate migration add_admin_to_users admin:boolean
class AddAdminToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :admin, :boolean
  end
end
