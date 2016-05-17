class Purchase::ProofOfPurchaseGeneration

  attr_accessor :purchase_presenter, :pdf_generator_service_class

  def intiliaze(options={})
  end

  # @return [ Hash ] with the success or errors
  def call(options={})
    raise "You must to provide a purchase param" if options[:purchase].blank?
    @purchase_presenter = ProofOfPurchasePresenter.new(options[:purchase], nil)
    @pdf_generator_service_class = options[:pdf_generator_service] || Purchase::PdfGenerator
    timestamp = options[:timestamp] || Time.now.to_i
    response = {}

    temporal_folder_path = "#{ Rails.root }/tmp/purchases/#{timestamp}"
    document_type = 'equivalent_document' # TODO: update this when it is made a invoice instead equiv_doc.
    temporal_file_path = "#{temporal_folder_path}/#{document_type}.pdf"

    if create_temporal_folder(temporal_folder_path)
      purchase_presenter = generate_file_for(@purchase_presenter, temporal_file_path, document_type)
      response[:success] = purchase_presenter.save!
      response[:errors] = purchase_presenter.errors.full_messages
    else
      raise 'The folder was not creted!'
    end
    response
  end

  private

  def generate_file_for(purchase_presenter, temporal_file_path, document_type)
    file = pdf_generator_service_class.new.call(purchase_presenter: purchase_presenter)
    file.render_file(temporal_file_path)
    purchase_presenter.build_proof_of_purchase(
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