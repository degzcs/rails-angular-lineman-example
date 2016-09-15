# Service PdfGeneration incarged to associate pdf files in memory to an specific order
class PdfGeneration
  attr_accessor :order_presenter, :draw_pdf_service_class

  def initialize
    @response = {}
    @response[:errors] = []
  end

  # @params option [ Hash ]
  # @return [ Hash ] with the success or errors
  def call(options = {})
    validate_sent_options(options)
    @order_presenter = OrderPresenter.new(options[:order], nil)
    @draw_pdf_service_class = options[:draw_pdf_service]
    file = define_temporal_dir_and_file(options)
    raise 'The folder was not creted!' unless create_temporal_folder(file.path_folder)
    order_presenter = generate_file_for(@order_presenter, file.path_file, file.name, options)
    @response[:success] = order_presenter.save!
    @response[:errors] << order_presenter.errors.full_messages
    @response
  end

  private

  # @params option [ Hash ]
  # @return [ Struct Object ] with the :path_folder, :path_file, :name as document_type
  def define_temporal_dir_and_file(options)
    timestamp = options[:timestamp] || Time.now.to_i
    document_type = options[:document_type]

    temporal_folder_path = "#{Rails.root}/tmp/sale_and_purchase_files/#{timestamp}"
    temporal_file_path = "#{temporal_folder_path}/#{document_type}.pdf"
    tmp = Struct.new(:path_folder, :path_file, :name)
    tmp.new(temporal_folder_path, temporal_file_path, document_type)
  end

  # Adds the temporal file to the passed order
  # @param order_presenter [ OrderPresenter ]
  # @param temporal_file_path [ String ]
  # @param document_type [ String ]
  # @param options [ Hash ]
  def generate_file_for(order_presenter, temporal_file_path, document_type, options)
    draw_pdf_service = draw_pdf_service_class.new
    draw_pdf_service.call(options.merge(order_presenter: order_presenter))
    file = draw_pdf_service.file
    file.render_file(temporal_file_path)
    order_presenter.documents.build(
      file: File.open(temporal_file_path),
      type: document_type
    )
  end

  # @param folder_path [ String ] where the files will be saved temporarily
  # @return [ Boolean ]
  def create_temporal_folder(folder_path)
    system <<-COMMAND
      mkdir -p #{folder_path} && cd #{folder_path}
    COMMAND
  end

  # Validates the incoming params to this service
  # @param options [ Hash ]
  def validate_sent_options(options)
    raise 'You must to provide a order param' if options[:order].blank?
    raise 'You must to provide a draw_pdf_service param' if options[:draw_pdf_service].blank?
    raise 'You must to provide a document_type param' if options[:document_type].blank?
  end
end
