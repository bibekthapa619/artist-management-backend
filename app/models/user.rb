class User < ApplicationRecord
    has_secure_password

    enum gender: { m: 0, f: 1, o: 2 }  
    enum role: { super_admin: 0, artist_manager: 1, artist: 2 }

    validates :first_name, :last_name, presence: true
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :password, presence: true, length: { minimum: 6 }
    validates :phone, presence: true, uniqueness: true, format: { with: /\A\d{10}\z/, message: "must be a 10-digit number" }

    has_many :artist_managers, -> { where(role: :artist_manager) }, class_name: 'User', foreign_key: :super_admin_id, dependent: :nullify
    has_many :artists, -> { where(role: :artist) },class_name: 'User', foreign_key: :super_admin_id, dependent: :nullify

    scope :artist_managers_only, -> { where(role: :artist_manager) }
    scope :artists_only, -> { where(role: :artist) }

    def as_json(options = {})
        super(options.merge(except: [:password_digest]))
    end

    def check_role(roles: [])
        roles.include?(role)
    end
end
