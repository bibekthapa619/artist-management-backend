class UserController < ApplicationController

    before_action :set_user_service
    before_action :authenticate_request
    before_action do
        has_role(roles:['super_admin'])
    end
    before_action :set_user, only: [:show, :update, :destroy]

    def index
        page = params[:page] || 1
        per_page = params[:per_page] || 10
        search = params[:search]
        sort = params[:sort_by]

        if sort == 'name-asc'
            sort = 'first_name asc, last_name asc, id asc'
        elsif sort == 'name-desc' 
            sort = 'first_name desc, last_name desc, id asc'
        elsif sort == 'last-modified'
            sort = 'updated_at desc, id asc'
        elsif sort == 'date-created'
            sort = 'id asc'
        else
            sort = 'first_name asc, last_name asc, id asc'
        end

        users = @user_service.list_users(page, per_page,@current_user.id ,search, sort)
        render_success(
            users,
            'Users fetched successfully'
        )
    end

    def show
        data = {
            user:@user
        }
        if(@user.role == 'artist')
            artist_service = ArtistService.new()
            artist = artist_service.find_artist_by_user_id(@user.id)
            data['artist'] = artist
        end
        render_success(data, 'User fetched successfully')
    end

    def create
        user = @user_service.create_user(user_params)

        render_success({ user: user }, 'User created successfully', :created)
    end

    def update
        result = @user_service.update_user(@user.id, user_update_params)

        render_success({ user: result }, 'User updated successfully')
        
    end

    def destroy
        @user_service.delete_user(@user.id)
        render_success(nil, 'User deleted successfully')
    end


    private

    def set_user
        @user = @user_service.find_user(params[:id])
    end

    def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :phone, :dob, :gender, :role, :address, :password).merge(super_admin_id: @current_user.id)
    end

    def user_update_params
        params.require(:user).permit(:first_name, :last_name, :email, :phone, :dob, :gender, :address)
    end

    def set_user_service
        @user_service = UserService.new()
    end

end
