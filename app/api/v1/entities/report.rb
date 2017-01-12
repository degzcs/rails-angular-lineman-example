
module V1
  module Entities
    # Entity of grape
    class Report < Grape::Entity
      expose :base_file_url, documentation: { type: 'string', desc: 'Allows to see the file path', example: '/url_root/public_dir_path/name_file.ext' }
    end
  end
end
