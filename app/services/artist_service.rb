class ArtistService
  include PaginationMeta
    def list_artists(page = 1, per_page = 10, search = nil)
      artists = Artist.select("artists.*, COUNT(musics.id) AS music_count")  
      .left_joins(:musics) 
      .group("artists.id")

      if search.present?
        artists = artists.where("name LIKE ?", "%#{search}%")
      end
  
      artists = artists.page(page).per(per_page)
  
      { 
        artists: artists, 
        meta: get_pagination_meta(artists)
      }
    end
  
    def find_artist(id)
      Artist.find_by(id: id)  
    end

    def find_artist_by_user_id(user_id)
      Artist.includes(:user).find_by(user_id: user_id)  
    end
  
    def create_artist(params)
      artist = Artist.new(params)
      artist.save!
      artist
    end
  
    def update_artist(id, params)
      artist = find_artist(id)
  
      artist.update!(params)
      artist
    end
  
    def delete_artist(id)
      artist = find_artist(id)
      artist.destroy!
    end
end
  