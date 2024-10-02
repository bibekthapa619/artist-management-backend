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


        users = @user_service.list_users(page, per_page,@current_user.id ,search)
        render_success(
            { 
                users: users, 
                meta: {
                    total_pages: users.total_pages, 
                    current_page: users.current_page,
                    total: users.total_count 
                } 
            }
        )
    end

    def show
        render_success({user: @user}, 'User fetched successfully')
    end

    def create
        user = @user_service.create_user(user_params)
        
        if user.save
            render_success({user: user}, 'User created successfully', :created)
        else
            render_error(user.errors.full_messages,'Something went wrong.' ,:unprocessable_entity)
        end
    end

    def update
        result = @user_service.update_user(@user.id, user_update_params)

        if result[:success]
            render_success({ user: result[:user] }, 'User updated successfully')
        else
            render_error(result[:user].errors.full_messages, 'Something went wrong.', :unprocessable_entity)
        end
    end

    def destroy
        if @user_service.delete_user(@user.id)
            render_success(nil, 'User deleted successfully')
        else
            render_error(nil, 'User not found', :not_found)
        end
    end


    private

    def set_user
        @user = @user_service.find_user(params[:id])

        unless @user
            render_error(nil, 'User not found', :not_found)
        end
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
