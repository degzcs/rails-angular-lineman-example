class PdfFile < Prawn::Document

  def initialize(context)
    super()
    text 'Leando dijo que no'
  end

end