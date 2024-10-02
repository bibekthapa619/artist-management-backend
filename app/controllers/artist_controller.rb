class ArtistController < ApplicationController
    before_action :set_artist_service
    before_action :set_user_service
    before_action :authenticate_request
    before_action only: [:create, :update,:index, :destroy] do
        has_role(roles:['super_admin', 'artist_manager'])
    end
    before_action :set_artist, only: [:show, :update, :destroy]

    def index
        page = params[:page] || 1
        per_page = params[:per_page] || 10
        search = params[:search]

        artists = @artist_service.list_artists(page, per_page, search)
        render_success(
            { 
                artists: artists, 
                meta: {
                    total: artists.total_count,
                    total_pages: artists.total_pages, 
                    current_page: artists.current_page, 
                }
            }, 
            'Artists fetched successfully'
        )
    end

    def show
        render_success({ artist: @artist.as_json(include: { user: { except: [:password_digest, :created_at, :updated_at] } }) }, 'Artist fetched successfully')
    end

    def create
        ActiveRecord::Base.transaction do
            user = @user_service.create_user(user_params)
            artist = @artist_service.create_artist(artist_params.merge(user_id: user.id))
            render_success({ artist: artist }, 'Artist created successfully', :created)
        end
    end

    def update
        ActiveRecord::Base.transaction do
            user = @user_service.update_user(@artist.user_id, user_params)
            artist = @artist_service.update_artist(params[:id], artist_params)
            render_success({ artist: artist }, 'Artist updated successfully')
        end
    end

    def destroy
        @user_service.delete_user(@artist.user_id) 
        render_success(nil, 'Artist deleted successfully')
    end

    private

    def set_artist
        @artist = @artist_service.find_artist(params[:id])
        render_error(nil, 'Artist not found', :not_found) unless @artist
    end

    def artist_params
        params.require(:artist).permit(:name, :first_release_year, :no_of_albums_released)
    end

    def user_params
        super_admin_id = @current_user.role == 'super_admin' ? @current_user.id : @current_user.super_admin_id
        params.require(:user).permit(:first_name, :last_name, :email ,:dob, :gender, :address, :phone, :password).merge(role: 'artist', super_admin_id: super_admin_id)
    end

    def set_artist_service
        @artist_service = ArtistService.new
    end

    def set_user_service
        @user_service = UserService.new
    end

end
