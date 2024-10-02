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
        Music.new(params)
    end
  
    def find_music(id)
        Music.find(id)
    rescue ActiveRecord::RecordNotFound
         nil
    end
  
    def update_music(id, params)
        music = find_music(id)
        return { success: false, music: nil } unless music
    
        if music.update(params)
            { success: true, music: music }
        else
            { success: false, music: music }
        end
    end
  
    def delete_music(id)
        music = find_music(id)
        return false unless music
    
        music.destroy
    end
  end
  