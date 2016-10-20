
module TermsAndConditions
	# Service incarged to associate the acceptance of term and conditions pdf files in memory to an specific provider
  class HabeasDataAgreetmentService
    attr_reader :signature_picture, :authorized_provider
    attr_accessor :response

    def initialize(_options = {})
      @response = {}
      @response[:errors] = []
    end

    # @params seller [User]
    def call(options = {})
      binding.pry
      @authorized_provider = options[:authorized_provider]
      @signature_picture = options[:signature_picture]
      @draw_pdf_service = ::TermsAndConditions::DrawPdf.new
      file_config = define_temporal_dir_and_file(options)
      create_temporal_folder(file_config.temporal_folder_path)
      service = generate_file_for!(@authorized_provider, @signature_picture, file_config.temporal_file_path)
      @response[:success] = @authorized_provider.save!
      @response[:errors] << @authorized_provider.errors.full_messages
      @response
    end

    private

    def define_temporal_dir_and_file(options)
      timestamp = options[:timestamp] || Time.now.to_i
      document_name = 'habeas_data_agreetment'

      temporal_folder_path = "#{Rails.root}/tmp/terms_and_conditions/#{timestamp}"
      temporal_file_path = "#{temporal_folder_path}/#{document_name}.pdf"
      tmp = Struct.new(:temporal_folder_path, :temporal_file_path)
      tmp.new(temporal_folder_path, temporal_file_path)
    end

    # @params[user]
    def generate_file_for!(authorized_provider, signature_picture, temporal_file_path)
      @draw_pdf_service.call(
        authorized_provider_presenter: UserPresenter.new(authorized_provider, nil),
        signature_picture: signature_picture
      )
      file = @draw_pdf_service.file
      file.render_file(temporal_file_path)
      binding.pry
      authorized_provider.profile.habeas_data_agreetment_file = File.open(temporal_file_path)
    end

    def create_temporal_folder(folder_path)
      system <<-COMMAND
        mkdir -p #{ folder_path } && cd #{ folder_path }
        COMMAND
    end
  end
end
