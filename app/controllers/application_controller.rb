class ApplicationController < ActionController::Base
    def render_success(data, message = 'Request was successful', status = :ok)
        render json: {
          status: 'success',
          message: message,
          data: data
        }, status: status
    end
    
    def render_error(errors, message = 'Something went wrong', status = :unprocessable_entity)
        render json: {
            status: 'error',
            message: message,
            errors: errors
        }, status: status
    end

    def authenticate_request
        header = request.headers['Authorization']
        token = header.split(' ').last if header
      
        begin
            decoded_token = JsonWebToken.decode(token)
            @current_user = User.find(decoded_token[:user_id]) if decoded_token
        rescue => e
            render json: { errors: 'Unauthorized' }, status: :unauthorized
        end
    end
end
