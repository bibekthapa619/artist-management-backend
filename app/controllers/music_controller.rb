class MusicController < ApplicationController
    before_action :authenticate_request 
    before_action only: [:create, :update, :destroy, :index] do
        has_role(roles:['artist'])
    end
    before_action :set_music_service
    before_action :set_artist_service
    before_action :set_artist, only: [:create, :update, :index]
    before_action :set_music, only: [:show, :update, :destroy]
    
    def index
        page = params[:page] || 1
        per_page = params[:per_page] || 10
        search = params[:search]
        artist_id = @artist.id
        sort = params[:sort_by]

        if sort == 'title-asc'
            sort = 'title asc, id asc'
        elsif sort == 'title-desc' 
            sort = 'title desc, id asc'
        elsif sort == 'last-modified'
            sort = 'updated_at desc, id asc'
        elsif sort == 'date-created'
            sort = 'id asc'
        else
            sort = 'title asc, id asc'
        end

        musics = @music_service.list_musics(page, per_page, search, artist_id,sort)
        
        render_success(
          musics,
          'Musics fetched successfully'
        )
    end
  
    def show
        render_success({ music: @music }, 'Music fetched successfully')
    end
  
    def create
        music = @music_service.create_music(music_params)
        render_success({ music: music }, 'Music created successfully', :created)
    end
  
    def update
        music = @music_service.update_music(params[:id], music_params)
  
        render_success({ music: music }, 'Music updated successfully')
        
    end
  
    def destroy
        @music_service.delete_music(params[:id])
        render_success(nil, 'Music deleted successfully')
        
    end
  
    private
  
    def set_music
        @music = @music_service.find_music(params[:id])
        render_error(nil, 'Music not found', :not_found) unless @music
    end
  
    def music_params
        params.require(:music).permit(:title, :album_name, :genre).merge(artist_id: @artist.id)
    end
  
    def set_music_service
        @music_service = MusicService.new
    end

    def set_artist_service
        @artist_service = ArtistService.new
    end

    def set_artist
        @artist = @artist_service.find_artist_by_user_id(@current_user.id)
    end
  
  end
  