module V1
  module Helpers
    module PurchaseHelper
      class << self

        def format_params(params)
          params.tap do
            trazoro = false
            files = params[:purchase].slice(:files)[:files]
            # origin_certificate_file = files.reject{|file| file['filename'] =~ /seller_picture/}.first
            seller_picture = files.select{|file| file['filename'] =~ /seller_picture/}.first
            signature_picture = files.select{|file| file['filename'] =~ /signature_picture/}.last

            # TODO: this implementattion has to be changed in order to work with the new trazoro purchase requiriments. This cause problems with the normal purchases.

            # if origin_certificate_file.nil? && params[:purchase][:sale_id].present?
            #   origin_certificate_file = Sale.find( params[:purchase][:sale_id] ).origin_certificate_file
            #   trazoro = true
            # end
            params[:gold_batch][:extra_info] = JSON.parse(params[:gold_batch][:extra_info])

            params[:purchase].except!(:files).merge!(seller_picture: seller_picture, signature_picture: signature_picture, trazoro: trazoro)
          end
        end

      end
    end
  end
end
