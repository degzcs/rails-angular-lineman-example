module Reports
  module Taxes
    class GenerateCsv
      attr_accessor :response, :base_file_url, :date, :order
      attr_reader :base_file

      def initialize()
        @response = {}
        @response[:success] = false
        @response[:errors] = []
      end

      def create_base_file_dir(dirname)
        FileUtils.mkdir_p(dirname) unless Dir.exists?(dirname)
      end

      def call(options = {})
        validate_options(options)
        base_dir = options[:file_dir] || "#{ Rails.root }/public/tmp/reports/taxes/#{options[:current_user].id}"
        create_base_file_dir(base_dir)
        @date = options[:date]
        @order = options[:order]
        @base_file = base_dir + "/taxes_#{@order.id}_#{@date}.cvs"
        generate!(options, @base_file)
        base_file_url
        @response[:success] = true
        self
      rescue => exception
        @response[:success] = false
        @response[:errors] << exception.message
      end

      #returns just the url to frontend path to this report file
      def base_file_url
        @base_file_url = @base_file[(/\/tmp\// =~ @base_file) + 1, @base_file.size - 1]
      end

      def generate!(options, base_file)
        csv = CSV.open(base_file,'w+', :col_sep => ';') do |csv|
          csv << ['Reporte Módulo Tributario', 'Transacción de Tipo: ' + options[:order].type.to_s, '', 'fecha: ' + options[:date].to_s, (print "\n")]
          csv << ['', '', '', '', (print "\n")]
          csv << ['CODIGO', 'CUENTA', 'DEBITO', 'CREDITO', (print "\n")]
          # by transaction do blocks with
          # Taxes
          csv << ['Movimientos e Impuestos', '', '', '']
          options[:report][:movements].each do |movement|
            csv << [movement.count, movement.name, movement.debit, movement.credit]
          end
          options[:report][:taxes].each do |movement|
            csv << [movement.count, movement.name, movement.debit, movement.credit ]
          end

          # inventory
          if options[:report][:inventories].present?
            csv << ['Inventario', '', '', ''] 
            options[:report][:inventories].each do |movement|
              csv << [movement.count, movement.name, movement.debit, movement.credit ]
            end
          end
          # pay
          csv << ['Pago', '', '', '']
          options[:report][:payments].each do |movement|
            csv << [movement.count, movement.name, movement.debit, movement.credit ]
          end
        end
      end

      def validate_options(options)
        raise "You must to provide a report option" if options[:report].blank?
        raise "You must to provide a date option" if options[:date].blank?
        raise 'You must to provide a current_user option' if options[:current_user].blank?
        raise 'You must to provide a order option' if options[:order].blank?
      end
    end
  end
end
