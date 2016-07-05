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
        def arrange(params)
          user_data = params.slice(User.columns_hash.except('id').keys)
          profile_data = params.slice(Profile.columns_hash.except('id').keys)
          user_date.merge!(profile_attributes: profile_data)
        end

      end
    end
  end
end
