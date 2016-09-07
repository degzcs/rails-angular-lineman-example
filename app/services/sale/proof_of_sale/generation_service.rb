class Sale::ProofOfSale::GenerationService

  attr_accessor :order_presenter, :draw_pdf_service_class

  def intiliaze(options={})
  end

  def call(options={})
    raise "You must to provide a sale_order param" if options[:sale_order].blank?
    @order_presenter = OrderPresenter.new(options[:sale_order], nil)
    @draw_pdf_service_class = options[:draw_pdf_service] || ::Sale::ProofOfSale::DrawPDF
    timestamp = options[:timestamp] || Time.now.to_i
    response = {}

    temporal_folder_path = "#{ Rails.root }/tmp/sales/#{ timestamp }"
    document_type = 'equivalent_document' # TODO: update this when it is made a invoice instead equiv_doc.
    temporal_file_path = "#{ temporal_folder_path }/#{ document_type }.pdf"

    if create_temporal_folder(temporal_folder_path)
      order_presenter = generate_file_for(@order_presenter, temporal_file_path, document_type)
      response[:success] = order_presenter.save!
      response[:errors] = order_presenter.errors.full_messages
    else
      raise 'The folder was not creted!'
    end
    response
  end

  private

  def generate_file_for(order_presenter, temporal_file_path, document_type)
    file = draw_pdf_service_class.new.call(order_presenter: order_presenter)
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