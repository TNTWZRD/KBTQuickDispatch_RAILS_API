module Api
  module V1
    class BaseController < ApplicationController
      include RackSessionFix
      respond_to :json

      def status
        render json: { status: 200, message: 'API Online' }, status: :ok
      end
      # Add more general API actions here
    end
  end
end
