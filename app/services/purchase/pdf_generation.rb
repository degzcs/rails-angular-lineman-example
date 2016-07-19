class Purchase::PdfGeneration

  attr_accessor :purchase_presenter, :draw_pdf_service_class

  def initialize(options={})
    @response = {}
    @response[:errors] = []
  end

  # @return [ Hash ] with the success or errors
  def call(options={})
    raise "You must to provide a purchase param" if options[:purchase].blank?
    raise "You must to provide a draw_pdf_service param" if options[:draw_pdf_service].blank?
    raise "You must to provide a document_type param" if options[:document_type].blank?
    @purchase_presenter = PurchasePresenter.new(options[:purchase], nil)
    @draw_pdf_service_class = options[:draw_pdf_service]
    timestamp = options[:timestamp] || Time.now.to_i
    document_type = options[:document_type]

    temporal_folder_path = "#{ Rails.root }/tmp/purchases/#{timestamp}"
    # document_type = 'equivalent_document' # TODO: update this when it is made a invoice instead equiv_doc.
    temporal_file_path = "#{temporal_folder_path}/#{document_type}.pdf"

    if create_temporal_folder(temporal_folder_path)
      purchase_presenter = generate_file_for(@purchase_presenter, temporal_file_path, document_type, options)
      @response[:success] = purchase_presenter.save!
      @response[:errors] << purchase_presenter.errors.full_messages
    else
      raise 'The folder was not creted!'
    end
    @response
  end

  private

  def generate_file_for(purchase_presenter, temporal_file_path, document_type, options)
    draw_pdf_service = draw_pdf_service_class.new
    response = draw_pdf_service.call(options.merge(purchase_presenter: purchase_presenter))
    file = draw_pdf_service.file
    file.render_file(temporal_file_path)
    purchase_presenter.documents.build(
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