class ApplicationController < ActionController::Base
    include ApiResponse
    include Authentication
    include ExceptionHandler
end
