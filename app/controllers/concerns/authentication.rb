module Authentication
    extend ActiveSupport::Concern
  
    def authenticate_request
      header = request.headers['Authorization']
      token = header.split(' ').last if header
  
      begin
        decoded_token = JsonWebToken.decode(token)
        @current_user = User.find(decoded_token[:user_id]) if decoded_token
      rescue => e
        render_error(nil, 'Unauthorized', :unauthorized)
      end
    end
  
    def has_role(roles:)
      unless @current_user.check_role(roles: roles)
        render_error(nil, 'Unauthorized: You do not have permission to perform this action.', :forbidden)
      end
    end
  end
  