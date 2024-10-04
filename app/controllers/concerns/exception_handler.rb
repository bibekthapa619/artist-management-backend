# app/controllers/concerns/exception_handler.rb
module ExceptionHandler
    extend ActiveSupport::Concern
  
    included do
      rescue_from StandardError, with: :internal_server_error
      rescue_from ActiveRecord::RecordNotFound, with: :not_found
      rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
    end
  
    private
  
    def not_found(exception)
      render_error(nil, 'Resource not found', :not_found)
    end
  
    def unprocessable_entity(exception)
      render_error(format_validation_errors(exception.record), 'Validation failed', :unprocessable_entity)
    end
  
    def internal_server_error(exception)
      render_error(nil, exception, :internal_server_error)
    end

    def format_validation_errors(record)
        return {} unless record.errors.any?
    
        record.errors.messages.transform_values do |messages|
          messages.map { |msg| msg.to_s }
        end
    end
  
end
  