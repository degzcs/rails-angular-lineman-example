module CarrierWave
  module CleanUpFolders
    extend ActiveSupport::Concern

    def delete_empty_upstream_dirs
      path = ::File.expand_path(store_dir, root)
      Dir.delete(path) # fails if path not empty dir

      path = ::File.expand_path(base_store_dir, root)
      Dir.delete(path) # fails if path not empty dir
    rescue SystemCallError
      true #
    end
  end
end