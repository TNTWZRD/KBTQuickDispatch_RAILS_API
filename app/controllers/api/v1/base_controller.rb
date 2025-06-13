module Api
  module V1
    class BaseController < ApplicationController
      include RackSessionFix
      respond_to :json

      def status
        render json: { status: 'ok' }, status: :ok
      end
      # Add more general API actions here
    end
  end
end
