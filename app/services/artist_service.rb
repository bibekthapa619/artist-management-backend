class ArtistService
    def list_artists(page = 1, per_page = 10, search = nil)
      artists = Artist.includes(:user) 

      if search.present?
        artists = artists.where("name LIKE ?", "%#{search}%")
      end
  
      artists = artists.page(page).per(per_page)
  
      artists
    end
  
    def find_artist(id)
      Artist.includes(:user).find_by(id: id)  
    end

    def find_artist_by_user_id(user_id)
        Artist.includes(:user).find_by(user_id: user_id)  
      end
  
    def create_artist(params)
      Artist.new(params)
    end
  
    def update_artist(id, params)
      artist = find_artist(id)
      return { success: false, artist: nil } unless artist
  
      if artist.update(params)
        { success: true, artist: artist }
      else
        { success: false, artist: artist }
      end
    end
  
    def delete_artist(id)
      artist = find_artist(id)
      artist&.destroy
    end
end
  