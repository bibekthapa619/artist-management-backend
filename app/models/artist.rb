class Artist < ApplicationRecord
    belongs_to :user
    has_many :musics
    
    validates :name, presence: true
    validates :first_release_year, presence: true, numericality: { only_integer: true }
    validates :no_of_albums_released, presence: true, numericality: { only_integer: true }
end
