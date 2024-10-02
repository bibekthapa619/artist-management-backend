class MusicService
    def list_musics(page = 1, per_page = 10, search = nil, artist_id = nil)
        musics = Music.all
    
        musics = musics.where(artist_id: artist_id) if artist_id.present?
    
        if search.present?
          musics = musics.where("title LIKE :search OR album_name LIKE :search", search: "%#{search}%")
        end
    
        musics.page(page).per(per_page)
    end
  
    def create_music(params)
        music = Music.new(params)
        music.save!
        music
    end
  
    def find_music(id)
        Music.find(id)
    end
  
    def update_music(id, params)
        music = find_music(id)
        music.update!(params)
    end
  
    def delete_music(id)
        music = find_music(id)
        music.destroy!
    end
  end
  