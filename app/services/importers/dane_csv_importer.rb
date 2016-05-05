class Importers::DaneCsvImporter
  #
  # Attributes
  #

  attr_accessor :file_path
  attr_accessor :errors
  attr_accessor :data

  #
  # Constants
  #

  ALLOWED_FIELDS=[:state_name, :state_code, :city_name, :city_code]

  def initialize(options={})
    @errors = []
    @data = []
  end

  #
  # Instance Methods
  #

  # @return [ Hash ]
  def call(options={})
    @file_path = options[:file_path]
    # open csv file and iterate over it.
    CSV.foreach(file_path, headers: true) do |row_data|
      printf '.'
      normalized_row = normalize_data(row_data.to_hash.symbolize_keys!.slice(*ALLOWED_FIELDS))

      country = Country.find_or_create_by(name: 'COLOMBIA')
      # Create or find State
      state_response = import_state(normalized_row, country)
      if state_response[:success]
        data << state_response[:instance]
      else
        errors << normalized_row.merge(error: state_response[:errors])
      end

      # Create or find City
      city_response = import_city(normalized_row, state_response[:instance]) if state_response[:success]
      if city_response[:success]
        data << city_response[:instance]
      else
        errors << normalized_row.merge(error: city_response[:errors])
      end

    end
    { successfully_imported: data , errors: errors.flatten!.try(:compact!).try(:uniq!) }
  end

  # @param row [ Hash ]
  # @param state [ State ]
  # @return [ Hash ]
  def import_city(row, state)
    city = City.find_or_create_by(name:row[:city_name], code: row[:city_code], state: state)
    city.valid?
    { success: city.persisted?, errors: city.errors, instance: city }
  end

  # @param row [ Hash ]
  # @return [ Hash ]
  def import_state(row, country)
    state = State.find_or_create_by(name: row[:state_name], code: row[:state_code], country: country)
    state.valid?
    { success: state.persisted?, errors: state.errors, instance: state }
  end

  # @param row [ Hash ]
  # @return [ Hash ]
  def normalize_data(row)
    row.tap do |row|
      row.each { |key , value| row[key] = upcase(value) }
      row[:state_code] = normalize_state_code(row[:state_code])
      row[:city_code] = normalize_city_code(row[:city_code])
    end
  end

  # @param city_code [ String ]
  # @return [ String ]
  def normalize_city_code(city_code)
    city_code.to_s.rjust(3, '0')
  end

  # @param state_code [ String ]
  # @return [ String ]
  def normalize_state_code(state_code)
    state_code.to_s.rjust(2, '0')
  end

  # Helps to handle latin characters and put them as upcase characters
  # @param string [ String ]
  # @return [ String ]
  def upcase(string)
    string.mb_chars.upcase.wrapped_string
  end
end