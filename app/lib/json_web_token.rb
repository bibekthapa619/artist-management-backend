class JsonWebToken
    SECRET_KEY = Rails.application.secrets.secret_key_base.to_s
  
    def self.encode(payload, exp = 24.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, SECRET_KEY)
    end
  
    def self.decode(token)
      decoded_token = JWT.decode(token, SECRET_KEY, true, { algorithm: 'HS256' })[0]
      HashWithIndifferentAccess.new(decoded_token)
    rescue JWT::ExpiredSignature
      raise "Token has expired"
    rescue JWT::DecodeError => e
      raise "Invalid token: #{e.message}"
    end
end
  