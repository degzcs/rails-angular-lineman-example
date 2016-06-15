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

      end
    end
  end
end
