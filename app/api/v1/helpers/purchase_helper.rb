module V1
  module Helpers
    module PurchaseHelper
      class << self

        def format_params(params)
          params.tap do
            trazoro = false
            files =params[:purchase].slice(:files)[:files]
            origin_certificate_file = files.reject{|file| file['filename'] =~ /seller_picture/}.first
            seller_picture = files.select{|file| file['filename'] =~ /seller_picture/}.first

            if origin_certificate_file.nil? && params[:purchase][:sale_id].present?
              origin_certificate_file = Sale.find( params[:purchase][:sale_id] ).origin_certificate_file
              trazoro = true
            end

            params[:purchase].except!(:files).merge!(origin_certificate_file: origin_certificate_file, seller_picture: seller_picture, trazoro: trazoro)
          end
        end

      end
    end
  end
end
