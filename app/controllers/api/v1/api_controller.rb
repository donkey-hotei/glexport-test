module Api
  module V1
    class ApiController < ApplicationController
      rescue_from ActionController::ParameterMissing, with: :error_occured
      rescue_from ActiveRecord::RecordNotFound, with: :error_occured
      rescue_from ActiveRecord::ActiveRecordError, with: :error_occured

      layout "api/application"
      before_action :initialize_errors
      before_action :set_filter

      respond_to :json
      protect_from_forgery with: :null_session

      private

      def initialize_errors
        @errors ||= []
        @status = :ok
      end

      def error!(*errors)
        @errors.concat(errors.uniq)
        @status = :error
      end

      def error_occured(error)
        error!(error)
      end

      def set_filter
        @filter = ShipmentsFilter.new(filter_params)
      end

      def filter_params
        params.permit(:transport_type)
      end
    end
  end
end
