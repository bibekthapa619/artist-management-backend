class AuthController < ApplicationController
    before_action :authenticate_request, only: [:logout, :me]
    
    def login
        user = User.find_by(email:login_params[:email])
        
        if user&.authenticate(login_params[:password])
            token = JsonWebToken.encode(user_id: user.id)
            render_success({user:user , token:token},'Login successful')
        else
            render_error(nil,'Invalid email or password')
        end
    end

    def register
        user = User.new(register_params)

        user.save!
        render_success(nil, 'Registration successful')

    end

    def logout
        render_success(nil, 'Logout successful')
    end

    def me
        render_success(@current_user,'User details fetched.')
    end

    private

    def login_params
        params.require(:email)
        params.require(:password)
        params.permit(:email, :password)
    end

    def register_params
        params.permit(:first_name, :last_name, :email, :password).merge(role: :super_admin)
    end

end
