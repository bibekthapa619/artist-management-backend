class ArtistController < ApplicationController
    before_action :authenticate_request
    before_action only: [:create, :update,:index, :destroy, :music] do
        has_role(roles:['super_admin','artist_manager'])
    end
    before_action only: [:export_csv, :import_csv] do
        has_role(roles:['artist_manager'])
    end
    before_action :set_artist_service
    before_action :set_user_service
    before_action :set_music_service, only: [:music]
    before_action :set_artist, only: [:show, :update, :destroy, :music]

    def index
        page = params[:page] || 1
        per_page = params[:per_page] || 10
        search = params[:search]

        artists = @artist_service.list_artists(page, per_page, search)
        render_success(
            artists, 
            'Artists fetched successfully'
        )
    end

    def show
        render_success({ artist: @artist,user:@artist.user }, 'Artist fetched successfully')
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

    def music
        page = params[:page] || 1
        per_page = params[:per_page] || 10
        search = params[:search]
    
        musics = @music_service.list_musics(page, per_page, search, @artist.id)
        
        render_success(
          musics,
          'Musics fetched successfully'
        )
    end

    def export_csv
        csv_data = @artist_service.export
    
        send_data csv_data, filename: "artists-#{Date.today}.csv", type: 'text/csv'
    end

    def import_csv
        if params[:file].nil?
            render json: { error: 'No file uploaded' }, status: :unprocessable_entity and return
        end
      
        csv_text = params[:file].read
        csv = CSV.parse(csv_text, headers: true)
      
        errors = [] 
      
        ActiveRecord::Base.transaction do
            csv.each_with_index do |row, index|
                user_params = {
                    first_name: row['first_name'],
                    last_name: row['last_name'],
                    email: row['email'],
                    phone: row['phone'],
                    dob: row['dob'],
                    gender: row['gender'],
                    address: row['address'],
                    password: 'password',
                    role: 'artist',
                    super_admin_id: @current_user.super_admin_id,
                }

                artist_params = {
                    name: row['artist_name'],
                    first_release_year: row['first_release_year'],
                    no_of_albums_released: row['no_of_albums_released']
                }

                begin
                    user = @user_service.create_user(user_params)
                    artist = @artist_service.create_artist(artist_params.merge(user_id: user.id))
                rescue ActiveRecord::RecordInvalid => e
                    errors << "At row number #{index + 2}: #{e.message}"
                    raise ActiveRecord::Rollback
                end
            end
        end
      
        if errors.any?
            render_error(errors,"Import error.",:unprocessable_entity)
        else
            render_success(nil,"Artists imported successfully.")
        end
    end

    private

    def set_artist
        @artist = @artist_service.find_artist(params[:id])
        render_error(nil, 'Artist not found', :not_found) unless @artist
    end

    def artist_params
        params.require(:artist).permit(:name, :no_of_albums_released, :first_release_year)
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

    def set_music_service
        @music_service = MusicService.new
    end

end
