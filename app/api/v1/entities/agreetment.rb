module V1
  module Entities
    # Agreetment returns from Settings the fixed sale agreetment text
    class Agreetment < Grape::Entity
      expose :fixed_sale_agreetment, documentation: { type: 'text', desc: 'fixed sale agreetment from settings', example: 'wherever' } do |settings|
        settings[:data].fetch(:fixed_sale_agreetment, '')
      end
      expose :habeas_data_agreetment, documentation: { type: 'text', desc: 'buy agreetment from settings', example: 'wherever' } do |settings|
        settings[:data].fetch(:habeas_data_agreetment, '')
      end
    end
  end
end
