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
          new_params [:profile_data] = params.slice(*Profile.columns_hash.except('id').keys)
          new_params
        end

        # It is used in Authorized providers endPoint
        # # @param params [ Hash ] => with files from the frontend
        # @return [ Hash ]
        def format_params_files(params)
          params.tap do
            trazoro = false
            files = params['profile'].slice('files')['files']
            photo_file = files.select{|file| file['filename'] =~ /photo_file/}.first
            document_number_file = files.select{|file| file['filename'] =~ /document_number_file/}.first
            mining_register_file = files.select{|file| file['filename'] =~ /mining_register_file/}.last

            add_files_to_profile = {
              :photo_file => photo_file,
              :id_document_file => document_number_file,
              :mining_authorization_file => mining_register_file
            }
            params['profile'].except!('files').merge!(add_files_to_profile)
          end
        end
      end
    end
  end
end
