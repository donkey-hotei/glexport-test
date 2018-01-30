module Api
  module V1
    class ShipmentsController < BaseController

      private

      def query_params
        @query_params ||=
          params.permit(:company_id, :transport_type, :product_id)
      end
    end
  end
end
