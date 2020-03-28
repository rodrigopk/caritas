# frozen_string_literal: true

module Api
  module Views
    module Institutions
      class Index
        include Api::View

        def render
          json_response = {
            institutions: institutions.map do |institution|
              {
                id: institution.id,
                name: institution.name,
                description: institution.description,
                website_url: institution.website_url,
                logo_url: institution.logo_url
              }
            end
          }

          raw json_response.to_json
        end
      end
    end
  end
end
