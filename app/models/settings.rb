# == Schema Information
#
# Table name: settings
#
#  id         :integer          not null, primary key
#  data       :text
#  created_at :datetime
#  updated_at :datetime
#

class Settings < ActiveRecord::Base
  # include Singleton
  serialize :data
  #
  # Intance Methods
  #

  @@instance = Settings.last || Settings.new

  def self.instance
    return @@instance
  end

  #
  # Class Methods
  #

  def self.serialized_attr_accessor(*args)
    args.each do |method_name|
      eval "
        def #{method_name}
          (self.data || {})[:#{method_name}]
        end
        def #{method_name}=(value)
          self.data ||= {}
          self.data[:#{method_name}] = value
        end
      "
    end
  end

  serialized_attr_accessor :monthly_threshold, :fine_gram_value, :vat_percentage

  private_class_method :new
end
