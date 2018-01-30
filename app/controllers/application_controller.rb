class ApplicationController < ActionController::Base
  include ActionController::MimeResponds
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session,
                       if: proc { |r| r.request.format.eql?("application/json") }


  private

  def page_param
    page = params[:page].to_i
    if page < 1
      1
    else
      page
    end
  end

  def json_request?
    request.format.json?
  end
end
