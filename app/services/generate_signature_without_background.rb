class GenerateSignatureWithoutBackground
  attr_accessor :response
  def initialize
    @response = {}
    @response[:errors] = []
  end

  # @param signature [ OpenStruct ] or Tempfile object
  # @return [ String ] with the image path converted, it means the image path without background.
  def call(signature_picture, timestamp = Time.now.to_i)
    signature = signature_picture.is_a?(Hash) ? OpenStruct.new(signature_picture) : signature_picture
    signature_file = File.read(signature.tempfile.path)
    folder_config = define_temporal_dir_and_file(timestamp: timestamp)
    create_temporal_folder(folder_config.temporal_folder_path)
    File.write(folder_config.income_image_path, signature_file)
    was_convert = remove_background_for(folder_config.income_image_path, folder_config.outcome_image_path)
    was_convert ? folder_config.outcome_image_path : raise('The image background cannot be remove!!!')
  rescue StandardError => e
    response[:errors] << "Error: #{e.message}"
    response
  end

  # @param income_image_path [ String ]
  # @param outcome_image_path [ String ]
  # @return [ Boolean ] truen when the command runs perfectly and false in other cases.
  def remove_background_for(income_image_path, outcome_image_path)
    system "convert #{ income_image_path } -fill none -fuzz 10% -draw 'matte 0,0 floodfill' -flop  -draw 'matte 0,0 floodfill' -flop #{ outcome_image_path }"
  end

  # @param folder_path [ String ] where the files will be saved temporarily
  # @return [ Boolean ]
  def create_temporal_folder(folder_path)
    system <<-COMMAND
      mkdir -p #{folder_path} && cd #{folder_path}
    COMMAND
  end

  # @params option [ Hash ]
  # @return [ Struct Object ] with the :temporal_folder_path, :income_image_path, :outcome_image_path
  def define_temporal_dir_and_file(options={})
    timestamp = options[:timestamp]
    filename = options[:filename] || 'signature'
    temporal_folder_path = "#{ Rails.root }/tmp/signatures/#{ timestamp }"
    income_image_path = "#{ temporal_folder_path }/#{ filename }.jpg"
    outcome_image_path = "#{ temporal_folder_path }/#{ filename }.png"
    tmp = Struct.new(:temporal_folder_path, :income_image_path, :outcome_image_path)
    tmp.new(temporal_folder_path, income_image_path, outcome_image_path)
  end
end
