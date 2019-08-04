# frozen_string_literal: true

class CreateDoorkeeperSSOTables < ActiveRecord::Migration[5.2]
  def change
    create_table :oauth_sso_sessions, id: false do |t|
      t.string :guid, unique: true, null: false
      t.bigint :resource_owner_id
      t.string :user_agent
      t.string :ip_address
      t.boolean :signed_out, default: false, null: false

      t.timestamps
    end

    add_column :oauth_access_grants, :sso_session_guid, :string
    add_index :oauth_access_grants, :sso_session_guid
    add_column :oauth_access_tokens, :sso_session_guid, :string
    add_index :oauth_access_tokens, :sso_session_guid
    add_column :oauth_applications, :sso, :boolean, default: false
  end
end
