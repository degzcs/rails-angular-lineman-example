module V1
  module Helpers
    module PurchaseHelper
      class << self

        def format_params(params)
          params.tap do
            files =params[:purchase].slice(:files)[:files]
            origin_certificate_file = files.reject{|file| file['filename'] =~ /seller_picture/}.first
            seller_picture = files.select{|file| file['filename'] =~ /seller_picture/}.first
            params[:purchase].except!(:files).merge!(origin_certificate_file: origin_certificate_file, seller_picture: seller_picture)
          end
        end

      end
    end
  end
end