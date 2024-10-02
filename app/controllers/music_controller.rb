class MusicController < ApplicationController
    before_action :authenticate_request 
    before_action only: [:create, :update, :destroy] do
        has_role(roles:['artist'])
    end
    before_action :set_music_service
    before_action :set_artist_service
    before_action :set_artist, only: [:create, :update]
    before_action :set_music, only: [:show, :update, :destroy]
    
    def index
        page = params[:page] || 1
        per_page = params[:per_page] || 10
        search = params[:search]
        artist_id = params[:artist_id]
    
        musics = @music_service.list_musics(page, per_page, search, artist_id)
        
        render_success(
          { 
            musics: musics, 
            meta: {
              total: musics.total_count,
              total_pages: musics.total_pages,
              current_page: musics.current_page,
            }
          },
          'Musics fetched successfully'
        )
    end
  
    def show
        render_success({ music: @music }, 'Music fetched successfully')
    end
  
    def create
        music = @music_service.create_music(music_params)
    
        if music.save
            render_success({ music: music }, 'Music created successfully', :created)
        else
            render_error(music.errors.full_messages, 'Something went wrong.', :unprocessable_entity)
        end
    end
  
    def update
        result = @music_service.update_music(params[:id], music_params)
  
        if result[:success]
            render_success({ music: result[:music] }, 'Music updated successfully')
        else
            render_error(result[:music].errors.full_messages, 'Something went wrong.', :unprocessable_entity)
        end
    end
  
    def destroy
        if @music_service.delete_music(params[:id])
            render_success(nil, 'Music deleted successfully')
        else
            render_error(nil, 'Music not found', :not_found)
        end
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
  
    def has_role(roles:)
        unless @current_user.check_role(roles: roles)
            render_error(nil, 'Unauthorized: You do not have permission to perform this action.', :forbidden)
        end
    end
  end
  