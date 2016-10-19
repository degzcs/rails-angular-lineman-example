module V1
  module Helpers
    module UserHelper
      class << self

        #
        # @param user [ User ]
        # @return [ User ]
        def legal_representative_from(user)
          if user.has_office?
            user.company.legal_representative
          else
            user
          end
        end

        # This method was created because the user information was separated into user and profile models
        # @param params [ Hash ]
        # @return [ Hash ]
        def rearrange_params(params)
          new_params = {}
          new_params[:user_data] = params.slice(*User.columns_hash.except('id').keys)
          new_params[:profile_data] = params.slice(*Profile.columns_hash.except('id').keys)
          new_params
        end

        # It is used to organize Authorized providers params
        # # @param params [ Hash ] => with files from the frontend
        # @return [ Hash ]
        def authorized_provider_params(params)
          params = params.deep_symbolize_keys
          # trazoro = false
          files = params[:files]
          photo_file = files.select{|file| file[:filename] =~ /photo_file/}.first
          id_document_file = files.select{|file| file[:filename] =~ /id_document_file/}.first
          mining_authorization_file = files.select{|file| file[:filename] =~ /mining_authorization_file/}.last
          habeas_data_agreetment_file = files.select{|file| file[:filename] =~ /habeas_data_agreetment_file/}.first
          add_files_to_profile = {
            :photo_file => photo_file,
            :id_document_file => id_document_file,
            :mining_authorization_file => mining_authorization_file,
            :habeas_data_agreetment_file => habeas_data_agreetment_file
          }
          params.except!(:files)
          params[:profile].merge!(add_files_to_profile)
          params
        end
      end
    end
  end
end
