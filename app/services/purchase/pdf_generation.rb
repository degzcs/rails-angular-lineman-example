class Purchase::PdfGeneration

  attr_accessor :order_presenter, :draw_pdf_service_class

  def initialize(options={})
    @response = {}
    @response[:errors] = []
  end

  # @return [ Hash ] with the success or errors
  def call(options={})
    raise "You must to provide a purchase_order param" if options[:purchase_order].blank?
    raise "You must to provide a draw_pdf_service param" if options[:draw_pdf_service].blank?
    raise "You must to provide a document_type param" if options[:document_type].blank?
    @order_presenter = OrderPresenter.new(options[:purchase_order], nil)
    @draw_pdf_service_class = options[:draw_pdf_service]
    timestamp = options[:timestamp] || Time.now.to_i
    document_type = options[:document_type]

    temporal_folder_path = "#{ Rails.root }/tmp/purchases/#{timestamp}"
    # document_type = 'equivalent_document' # TODO: update this when it is made a invoice instead equiv_doc.
    temporal_file_path = "#{temporal_folder_path}/#{document_type}.pdf"

    if create_temporal_folder(temporal_folder_path)
      order_presenter = generate_file_for(@order_presenter, temporal_file_path, document_type, options)
      @response[:success] = order_presenter.save!
      @response[:errors] << order_presenter.errors.full_messages
    else
      raise 'The folder was not creted!'
    end
    @response
  end

  private

  def generate_file_for(order_presenter, temporal_file_path, document_type, options)
    draw_pdf_service = draw_pdf_service_class.new
    response = draw_pdf_service.call(options.merge(order_presenter: order_presenter))
    file = draw_pdf_service.file
    file.render_file(temporal_file_path)
    order_presenter.documents.build(
      file: File.open(temporal_file_path),
      type: document_type,
      )
  end

  # @param folder_path [ String ] where the files will be saved temporarily
  # @return [ Boolean ]
  def create_temporal_folder(folder_path)
    system <<-COMMAND
      mkdir -p #{ folder_path } && cd #{ folder_path }
    COMMAND
  end
end