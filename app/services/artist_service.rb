require 'csv'

class ArtistService
  include PaginationMeta
    def list_artists(page = 1, per_page = 10, search = nil, sort = nil)
      artists = Artist.select("artists.*, COUNT(musics.id) AS music_count")  
      .left_joins(:musics) 
      .group("artists.id")

      if search.present?
        artists = artists.where("name LIKE ?", "%#{search}%")
      end

      if sort.present?
        artists = artists.order(sort)
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


    def export
      artists = Artist.includes(:user).all 

      csv_data = CSV.generate(headers: true) do |csv|
        csv << ["first_name", "last_name", "email", "phone", "dob", "gender", "address", "artist_name", "first_release_year", "no_of_albums_released"]

        artists.each do |artist|
          user = artist.user
          csv << [
            user.first_name,
            user.last_name,
            user.email,
            user.phone,
            user.dob,
            user.gender,
            user.address,
            artist.name,
            artist.first_release_year,
            artist.no_of_albums_released
          ]
        end
      end

      csv_data
    end

end
  