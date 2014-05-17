class CreateMfaTokens < ActiveRecord::Migration
  def change
    add_column :users, :mfa_access_token, :string
    add_column :users, :mfa_authenticated, :boolean
  end
end
