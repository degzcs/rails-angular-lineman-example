# This Module contains all about the scraper Rucom Service
module RucomServices
  require 'yaml'
  #  RucomServices::Setting loads the config *.yml file with the values to initiliaze the RucomServices::Scraper.
  class Setting
    YAML_NAME = 'rucom_service.yml'.freeze
    YAML_PATH = Rails.root.join('config')
    attr_accessor :response, :response_class, :page_url, :driver, :browser, :driver_instance,
                  :table_body_id, :hidden_elements_id, :wait_load, :wait_clic, :barequero, :chatarrero, :trader
    attr_reader :send_data

    def initialize
      @response = {}
      @response[:errors] = []
    end

    def call(options = {})
      @file_name = options.fetch(:yaml_file_name, YAML_NAME)
      @file_path = options.fetch(:yaml_file_path, YAML_PATH)
      @response[:config] = YAML.load_file(File.join(@file_path, @file_name))[Rails.env]
      @response[:success] = true if @response[:config]
      @response[:send_data] = ordering_options(options)
      self
    rescue StandardError => e
      @response[:errors] << e.message
      self
    end

    #
    # options => is a hash with the keys and values sent from the frontend
    #            example: {id_number: '123123', id_type: 'NIT', rol_name: 'Barequero'}
    #
    def ordering_options(options)
      {
        rol_name: options.fetch(:rol_name, nil),
        id_type: options.fetch(:id_type, nil),
        id_number: options.fetch(:id_number, nil)
      }
    end

    def success
      @success = @response[:success] ? true : false
    end

    def errors
      @errors = @response[:errors]
    end

    def response_class
      key_rol = role_name.downcase
      if @response[:config]['scraper'].key?(key_rol)
        @response_class = @response[:config]['scraper'][key_rol]['response_class']
      else
        @response[:errors] << "response_class: The key no Exist!. Key: #{key_rol}"
        nil
      end
    end

    def page_url
      include_warning_inside_errors?('page_url', 'page_url: Should setting up the page_url')
      @page_url = @response[:config]['scraper'].fetch('page_url', nil)
    end

    def table_body_id
      include_warning_inside_errors?('table_body_id', 'table_body_id: Should setting up the table_body_id')
      @table_body_id = @response[:config]['scraper'].fetch('table_body_id', nil)
    end

    def driver
      include_warning_inside_errors?('driver', 'driver: Should setting up the driver')
      @driver = @response[:config]['scraper'].fetch('driver', nil)
    end

    def browser
      include_warning_inside_errors?('browser', 'browser: Should setting up the browser')
      @browser = @response[:config]['scraper'].fetch('browser', nil)
    end

    def driver_instance
      @driver_instance ||=
        if driver && browser
          driver.constantize.for(browser, {args: ['--ssl-protocol=any','--ignore-ssl-errors=true',  '--web-security=no', '--webdriver-loglevel=DEBUG', '--debug=true'] })
        else
          @response[:errors] << 'driver_instance: Should setting up the driver and browser'
          nil
        end
    end

    def hidden_elements_id
      @hidden_elements_id = @response[:config]['scraper'].fetch('hidden_elements_id', [])
    end

    def barequero
      include_warning_inside_errors?('barequero')
      @barequero = @response[:config]['scraper']['barequero'].fetch('select_options', [])
    end

    def chatarrero
      include_warning_inside_errors?('chatarrero')
      @chatarrero = @response[:config]['scraper']['chatarrero'].fetch('select_options', [])
    end

    def trader
      include_warning_inside_errors?('trader')
      @trader = @response[:config]['scraper']['trader'].fetch('select_options', [])
    end

    def clic_button_id
      include_warning_inside_errors?('clic_button_id', 'clic_button_id: Should set up clic_button_id')
      @clic_button_id = @response[:config]['scraper'].fetch('clic_button_id', nil)
    end

    def wait_load
      @wait_load = @response[:config]['scraper'].fetch('wait_load', 10).to_i
    end

    def wait_clic
      @wait_clic = @response[:config]['scraper'].fetch('wait_clic', 2).to_i
    end

    def role_name
      if trader.include?(@response[:send_data][:rol_name])
        'trader'
      elsif barequero.include?(@response[:send_data][:rol_name])
        'barequero'
      elsif chatarrero.include?(@response[:send_data][:rol_name])
        'chatarrero'
      else
        'unknown'
      end
    end

    def send_data
      @response[:send_data] || {}
    end

    private

    def include_warning_inside_errors?(key, str_msg = '')
      msg = str_msg || "#{key}: Should setting up the #{key}/select_options"
      @response[:errors] << msg if @response[:config]['scraper'][key].blank?
      @response[:config]['scraper'][key].blank? ? true : false
    end
  end
end
