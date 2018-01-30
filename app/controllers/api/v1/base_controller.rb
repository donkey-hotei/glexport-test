module Api
  module V1
    class BaseController < ApiController
      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

      # POST /api/{plural_resource_name}
      def create
        set_resource(create_resource(resource_params))

        if get_resource.save
          render :show, status: :created
        else
          error!(*get_resource.errors.full_messages)
          render :nothing, status: :unprocessable_entity
        end
      end

      # DELETE /api/{plural_resource_name}/1
      def destroy
        set_resource
        if get_resource.destroy
          head :no_content
        else
          error!(*get_resource.errors.full_messages) if get_resource.errors.any?
          render :nothing, status: :unprocessible_entity
        end
      end

      # GET /api/{plural_resource_name}
      def index
        resources = paginate(scope(resource_class))

        plural_resource_name = "@#{resource_name.pluralize}"
        instance_variable_set(plural_resource_name, resources)
        respond_with instance_variable_get(plural_resource_name)
      end

      # GET /api/{plural_resource_name}/1
      def show
        set_resource
        respond_with get_resource
      end

      # PATCH/PUT /api/{plural_resource_name}/1
      def update
        set_resource
        if get_resource.update(resource_params)
          render :show
        else
          error!(*get_resource.errors.full_messages)
          render :show, status: :unprocessable_entity
        end
      end

      private

      # Handles deleting session so we don't set cookie in API response
      def destroy_session
        request.session_options[:skip] = true
      end

      # Scopes the resource class
      def scope(resource_class)
        resource_class.where(query_params)
      end

      # Returns a new resource, override to set current_user etc
      # @return [Object]
      def create_resource(_params)
        resource_class.new(resource_params)
      end

      # Returns the resource from the created instance variable
      # @return [Object]
      def get_resource
        instance_variable_get("@#{resource_name}")
      end

      # Returns the allowed parameters for searching
      # Override this method in each API controller
      # to permit additional parameters to search on
      # @return [Hash]
      def query_params
        {}
      end

      # Returns the allowed parameters for pagination
      # @return [Hash]
      def page_params
        params.permit(:page, :page_size)
      end

      # The resource class based on the controller
      # @return [Class]
      def resource_class
        @resource_class ||= resource_name.classify.constantize
      end

      # The singular name for the resource class based on the controller
      # @return [String]
      def resource_name
        @resource_name ||= controller_name.singularize
      end

      # Only allow a trusted parameter "white list" through.
      # If a single resource is loaded for #create or #update,
      # then the controller for the resource must implement
      # the method "#{resource_name}_params" to limit permitted
      # parameters for the individual model.
      def resource_params
        @resource_params ||= send("#{resource_name}_params")
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_resource(resource = nil)
        resource ||= resource_class.find(params[:id])
        check_action_whitelisted!(params[:action])
        authorize! params[:action].to_sym, resource
        instance_variable_set("@#{resource_name}", resource)
      end

      def record_not_found(error)
        @errors << error.to_s
        render root_path, status: :unprocessible_entity
      end

      # Paginate only trip and report resources.
      def paginate(resources)
        resources.paginate(
          page: page_params[:page],
          per_page: page_params[:per]
        )
      end

      def check_action_whitelisted!(action)
        return true if %w[create show update destroy].include? action
        raise AbstractController::ActionNotFound, "#{action} is not whitelisted in API."
      end
    end
  end
end
