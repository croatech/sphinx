require 'sequel'

class User < Sequel::Model
  def validate
    errors.add(:mac_address, 'cannot be empty') if mac_address.nil?
    validates_format /^([0-9a-fA-F]{2}[:-]){5}[0-9a-fA-F]{2}$/i, :mac_address
  end

  def self.authorize!(env)
    auth_value = env.select { |key, _| key.include?('HTTP_') }['HTTP_AUTHORIZATION']
    Users::CurrentUserService.new.call(auth_value).result
  end

  def active_game
    Game.active.where(user_id: self.id).first
  end
end

# Table: users
# Columns:
#  id          | integer | PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY
#  mac_address | text    | NOT NULL
# Indexes:
#  users_pkey            | PRIMARY KEY btree (id)
#  users_mac_address_key | UNIQUE btree (mac_address)
