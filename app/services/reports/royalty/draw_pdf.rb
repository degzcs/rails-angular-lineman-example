# Draw application shipment authorization and/or
module Reports
  class Royalty::DrawPdf < Prawn::Document
    attr_accessor :base_file, :report, :user_presenter

    def initialize(options = {})
      super(skip_page_creation: true)
      @response = {}
      @response[:success] = false
      @response[:errors] = []
    end

    def call(options = {})
      validate_options(options)
      @report = options[:report]
      @user_presenter = ::UserPresenter.new(options[:current_user], nil)
      @base_file = options[:base_file] || File.open(File.join(Rails.root, 'vendor','pdfs','regalias.pdf'))
      begin
        draw_file!(
          user_presenter,
          report,
          options[:date],
          options[:signature_picture]
          )
        @response[:success] = true
      rescue => exception
        @response[:success] = false
        @response[:errors] << exception.message
      end
      @response
    end

    def file
      self
    end

    def draw_file!(user_presenter, report, date, signature_picture)
      start_new_page({ :template => "#{base_file.path}", :template_page => 1 })
      font_size 8

      #
      # Company section
      #
      move_cursor_to 680
      text_box report.company.name, :at => [10, cursor + 30], :width => 300, :height => 15, :overflow => :shrink_to_fit
      text_box 'X', :at => [360, cursor + 42 ], :width => 300, :height => 15, :overflow => :shrink_to_fit
      text_box report.company.nit_number, :at => [360, cursor + 30], :width => 300, :height => 15, :overflow => :shrink_to_fit
      text_box "#{ report.company.city.name }, #{ report.company.state.name }", :at => [10, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit
      text_box report.company.address, :at => [200, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit
      text_box report.company.phone_number, :at => [295, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit
      text_box report.company.email, :at => [380, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit

      #
      # Mineral section
      #
      move_cursor_to 625
      text_box 'Metal Precioso', :at => [10, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit
      text_box report.mineral_presentation, :at => [300, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit

      #
      # Production mineral section
      #

      #
      # Concept section
      #
      move_cursor_to 512
      text_box 'X', :at => [15, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit

      #
      # Period section
      #
      move_cursor_to 455
      case report.period
        when 1
          text_box 'XXX', :at => [55, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit
        when 2
          text_box 'XXX', :at => [160, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit
        when 3
          text_box 'XXX', :at => [270, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit
        when 4
          text_box 'XXX', :at => [380, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit
      end
      text_box report.year, :at => [460, cursor + 5], :width => 300, :height => 15, :overflow => :shrink_to_fit

      #
      # Payment of royalities section
      #
      move_cursor_to 350
      text_box report.mineral_type, :at => [40, cursor + 50], :width => 300, :height => 15, :overflow => :shrink_to_fit
      text_box report.fine_grams.to_s, :at => [125, cursor + 50], :width => 300, :height => 15, :overflow => :shrink_to_fit
      text_box report.unit, :at => [165, cursor + 50], :width => 300, :height => 15, :overflow => :shrink_to_fit
      text_box report.base_liquidation_price.to_s, :at => [225, cursor + 50], :width => 300, :height => 15, :overflow => :shrink_to_fit

      text_box report.unit, :at => [300, cursor + 50], :width => 300, :height => 15, :overflow => :shrink_to_fit
      text_box report.royalty_percentage.to_s, :at => [370, cursor + 50], :width => 300, :height => 15, :overflow => :shrink_to_fit
      text_box report.total.to_s, :at => [440, cursor + 50], :width => 300, :height => 15, :overflow => :shrink_to_fit

      # TODO: What happen here when there are more than 1 destination?????
      text_box report.company.name, :at => [50, cursor + 15], :width => 300, :height => 15, :overflow => :shrink_to_fit
      text_box report.total.to_s, :at => [440, cursor + 15], :width => 300, :height => 15, :overflow => :shrink_to_fit

      #
      # Destination section
      #
      # TODO: allow fill up when there are 2 more destinations
      move_cursor_to 300
      text_box report.destinations.first.name, :at => [40, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit
      text_box report.destinations.first.address, :at => [225, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit
      text_box report.destinations.first.city.name, :at => [360, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit
      text_box report.fine_grams.to_s, :at => [455, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit

      #
      # Signature section
      #
      service = ::GenerateSignatureWithoutBackground.new
      signature_path = service.call(signature_picture)
      move_cursor_to 220
      image(signature_path, :at => [20, cursor + 10], :fit => [200, 80])
      text_box date.to_s, :at => [325, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit
    end

    def validate_options(options)
      raise "You must to provide a report option" if options[:report].blank?
      raise "You must to provide a signature_picture option" if options[:signature_picture].blank?
      raise "You must to provide a date option" if options[:date].blank?
    end
  end
end
