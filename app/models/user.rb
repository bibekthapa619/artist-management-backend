class User < ApplicationRecord
    has_secure_password

    enum gender: { m: 0, f: 1, o: 2 }  
    enum role: { super_admin: 0, artist_manager: 1, artist: 2 }

    validates :email, :phone, uniqueness: true

    has_many :artist_managers, class_name: 'User', foreign_key: :super_admin_id, dependent: :nullify
    has_many :artists, class_name: 'User', foreign_key: :super_admin_id, dependent: :nullify

    scope :artist_managers_only, -> { where(role: :artist_manager) }
    scope :artists_only, -> { where(role: :artist) }

    def as_json(options = {})
        super(options.merge(except: [:password_digest]))
    end
end
