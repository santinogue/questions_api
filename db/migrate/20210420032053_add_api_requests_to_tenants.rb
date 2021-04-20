class AddApiRequestsToTenants < ActiveRecord::Migration[5.2]
  def change
    add_column :tenants, :api_requests, :integer, default: 0
  end
end
