class AuthController < ApplicationController
    
    def login
        user = User.find_by(email:login_params[:email])
        
        if user&.authenticate(login_params[:password])
            token = JsonWebToken.encode(user_id: user.id)
            render_success({user:user , token:token},'Login successful')
        else
            render_error(nil,'Invalid email or password')
        end
    end

    private

    def login_params
        params.require(:email)
        params.require(:password)
        params.permit(:email, :password)
    end

end
