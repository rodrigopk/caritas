# frozen_string_literal: true

module Containers
  module Institutions
    extend Dry::Container::Mixin

    register :repository do
      InstitutionRepository.new
    end
  end
end
