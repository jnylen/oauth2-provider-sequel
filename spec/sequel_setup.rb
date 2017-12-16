require 'sequel'

Sequel::Model.plugin :polymorphic
Sequel::Model.plugin :timestamps

# DB = Sequel.sqlite # :memory
DB = Sequel.connect(ENV['DATABASE_URL'])

puts "Using DB=[#{ENV['DATABASE_URL']}]"

DB.create_table!(:oauth2_clients) do
  primary_key :id
  String     :oauth2_client_owner_type
  Integer    :oauth2_client_owner_id
  String     :name
  String     :client_id
  String     :client_secret_hash
  String     :redirect_uri
  DateTime   :created_at
  DateTime   :updated_at

  index :client_id, :unique => true
  index :name, :unique => true
end

DB.create_table!(:oauth2_authorizations) do
  primary_key :id
  String     :oauth2_resource_owner_type
  Integer    :oauth2_resource_owner_id
  Integer    :oauth2_clients
  Integer    :client_id
  String     :scope
  String     :code,               :limit => 40
  String     :access_token_hash,  :limit => 40
  String     :refresh_token_hash, :limit => 40
  DateTime   :expires_at
  DateTime   :created_at
  DateTime   :updated_at

  index [:client_id, :code], :unique => true
  index :access_token_hash, :unique => true
  index [:client_id, :oauth2_resource_owner_type, :oauth2_resource_owner_id], :name => 'index_owner_client_pairs', :unique => true
  index [:client_id, :refresh_token_hash], :unique => true
end

DB.create_table!(:users) do
  primary_key :id
  String :name
end
