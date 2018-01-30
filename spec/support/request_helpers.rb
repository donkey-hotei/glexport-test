module Requests
  module JsonHelpers
    def json
      JSON.parse(response.body)
    end

    def default_headers
      { "Accept": "application/json",
        "Content-Type": "applcation/json" }
    end
  end
end
