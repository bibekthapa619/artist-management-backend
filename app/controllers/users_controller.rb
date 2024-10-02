class UsersController < ApplicationController

    before_action :authenticate_request
    before_action :set_user, only: [:show]

    def index
        users = User.all
        render json: users
    end

    def show
        render json: {
            user: @user,
        }, status: :ok
    end

    def create
        user = User.new(user_params)
        
        if user.save
          render json: { message: 'User created successfully', user: user }, status: :created
        else
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    private

    def set_user
        @user = User.find(params[:id])
        rescue ActiveRecord::RecordNotFound
        render json: { error: 'User not found' }, status: :not_found
    end

    def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :phone, :dob, :gender, :role, :address, :password)
    end

end
