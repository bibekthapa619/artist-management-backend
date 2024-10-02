module ApiResponse
    extend ActiveSupport::Concern
  
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
end
  