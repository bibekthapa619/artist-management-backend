module JsonWebTokenHelper
    def generate_token_for(user)
      JsonWebToken.encode(user_id: user.id)
    end
end
  