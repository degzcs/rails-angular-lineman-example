#This Generator joins all sold batches in one unique pdf.
module Sale
  module PurchaseFilesCollection
    class Generation
      attr_accessor :sale_order, :response

      def initialize(options={})
      end

      def call(options={})
        raise 'You must to set the sale_order option' if options[:sale_order].blank?
        @sale_order = options[:sale_order]
        files = options[:files] || []
        timestamp = options[:timestamp] || Time.now.to_i
        @response = {}
        purchases = sale_order.batches.map{ |sold_batch| sold_batch.gold_batch.goldomable }

        temporal_file_location = if APP_CONFIG[:USE_AWS_S3] || Rails.env.production?
                                  file_paths = purchase_files_from_aws_s3(purchases)
                                  exec_commands_on_aws_s3!(file_paths, timestamp)
                                else
                                  files = purchase_files_from_local_machine(purchases)
                                  exec_commands_on_local_machine!(files, timestamp)
                                end
        @response = generate_file_for!(sale_order, temporal_file_location)
      end

      private

      # @param sale_order [ Order ]
      # @param file [ File ]
      # @return [ Hash ] with the response
      def generate_file_for!(sale_order, file)
        sale_order.documents.build(
          file: open(file),
          type: 'purchase_files_collection'
          )
        { success: sale_order.save, errors: sale_order.errors.full_messages }
      end

      # Makes the whole process with files saved in the local machine
      # @param file_paths [ Array ]
      # @param timestamp [ Integer ]
      # @return [ String ] with the temporal file location
      def exec_commands_on_local_machine!(file_paths, timestamp)
        final_temporal_file_name = "purchase-files-#{ timestamp }.pdf"
        folder_path = "#{ Rails.root }/tmp/purchase_files_collection/#{ timestamp }"

        if create_temporal_folder(folder_path)
          join_files(extract_relative_path(folder_path), file_paths, final_temporal_file_name)
        else
          raise 'The folder was not created!'
        end
      end

      def extract_relative_path(folder_path)
        raise 'current_folder_relative_path: Error, no se envió la cadena correspondiente al path' unless folder_path.present?
        ini = (folder_path =~ /tmp/).to_i
        folder_path[ini..-1]
      end

      # Makes the whole process will files saved in WAS S3
      # @param files [ Array ]
      # @param timestamp [ Intenger ]
      # @return [ String ] with the temporal file location
      # TODO: check if it is better to use AWS Lambda instead to download
      # all files to the EC2 instance.
      def exec_commands_on_aws_s3!(files, timestamp)
        final_temporal_file_name = "purchase-files-#{ timestamp }.pdf"
        folder_path = "#{ Rails.root }/tmp/purchase_files_collection/#{ timestamp }"

        if create_temporal_folder(folder_path)
          temporal_files = download_files!(folder_path, files)
          file_paths = temporal_files.map{ |file| file[:filename] }
          join_files(extract_relative_path(folder_path), file_paths, final_temporal_file_name)
        else
          raise 'The folder was not creted!'
        end
      end


      # @param folder_path [ String ] where the files will be saved temporarily
      # @param temporal_files [ Array ] of Hashes
      # @param final_temporal_file_name [ String ]
      # @return [ String ] with the temporal file location
      def join_files(folder_path, file_paths, final_temporal_file_name)
        joined_file_paths = file_paths.join(' ')
        # NOTE: if it is needed you can add  -density 50 to the next command
        Dir.chdir(folder_path) do
          system <<-COMMAND
            convert -format pdf #{ joined_file_paths } #{ final_temporal_file_name }
          COMMAND
        end
        temporal_file_location = "#{ folder_path }/#{ final_temporal_file_name }"
      end

      # @param folder_path [ String ] where the files will be saved temporarily
      # @return [ Boolean ]
      def create_temporal_folder(folder_path)
        system <<-COMMAND
          mkdir -p #{ folder_path } && cd #{ folder_path }
        COMMAND
      end

      # @param folder_path [ String ] where the files will be saved temporarily
      # @param files [ Array ] of DocumentUploader instances
      # @return [ Hash ]
      def download_files!(folder_path, files)
        files.map do |file|
          filename = filename_from(file)
          {
            filename: filename,
            size: File.open("#{ folder_path }/#{ filename }", 'wb'){|f| f.write(file.read)}
          }
        end
      end

      # @param file [ DocumentUploader ]
      # @ return [ String ] with a temporal unique filename
      def filename_from(file)
        "#{ file.model.created_at.to_i }-#{ file.current_path.split('/').last }"
      end

      # DEPRECATED
      # Gets all origin certificate files from the current sale
      # @return [ Array ] of DocumentUploader
      def origin_certificate_files_from_aws_s3
        sale.batches.map{ |batch| batch.purchase.origin_certificate.file }
      end

      # DEPRECATED
      # Gets all origin certificate files from the current sale
      # @return [ Array ] of file paths
      def origin_certificate_files_from_local_machine
        sale.batches.map { |batch| Rails.root.join(batch.purchase.origin_certificate.file.path).to_s }
      end

      # @param purchase_orders [ Array ] with all Purchase related with the current sale
      # @return [ Array ] with all documents (ActiveRecord) belonging to the  given purchase
      def purchase_files_from_aws_s3(purchase_orders)
        binding.pry
        files = []
        purchase_orders.each do |purchase_order|
        # Origin certificate
        files << purchase_order.origin_certificate.file
        # ID
        files << purchase_order.seller.profile.id_document_file
        # barequero id OR miner register OR resolution
        files << purchase_order.seller.profile.mining_authorization_file if purchase_order.seller.profile.mining_authorization_file.file.present?
        # RUT
        files << purchase_order.seller.profile.rut_file if purchase_order.seller.profile.rut_file.file.present?
        # purchase_order equivalent document
        files << purchase_order.proof_of_purchase.file
        end
        files
      end

      # @param purhcase [ Array ] with all Purchase related with the current sale
      # @return [ Array ] with all document paths belonging to the  given purchase
      def purchase_files_from_local_machine(purchase_orders)
        file_paths = []
        purchase_orders.each do |purchase_order|
        # Origin certificate
        file_paths << Rails.root.join(purchase_order.origin_certificate.file.path)
        # ID
        file_paths << Rails.root.join(purchase_order.seller.profile.id_document_file.path)
        # barequero id OR miner register OR resolution
        file_paths << Rails.root.join(purchase_order.seller.profile.mining_authorization_file.path) if purchase_order.seller.profile.mining_authorization_file.file.present?
        # RUT
        file_paths << Rails.root.join(purchase_order.seller.profile.rut_file.path) if purchase_order.seller.profile.rut_file.file.present?
        # purchase_order equivalent document
        file_paths << Rails.root.join(purchase_order.proof_of_purchase.file.path)
        end
        file_paths
      end
    end
  end
end
