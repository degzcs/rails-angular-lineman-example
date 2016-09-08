# == Schema Information
#
# Table name: gold_batches
#
#  id              :integer          not null, primary key
#  fine_grams      :float
#  grade           :integer
#  created_at      :datetime
#  updated_at      :datetime
#  extra_info      :text
#  goldomable_type :string(255)
#  goldomable_id   :integer
#  sold            :boolean          default(FALSE)
#

# NOTE: the fine_grams are the resulting from grams*grade/999 (999 is the maximun gold purity percentage)
# the plataform make transaction with the fine grams, but in the extra_info you will be able to
# find where this value come from. See the measurement_converter_service.coffee file for more information

# Lote de oro
class GoldBatch < ActiveRecord::Base
  #
  # Serialized field
  # Example,
  # {
  #  grams: 7,
  #  castellanos: 5,
  #  tomines: 8,
  #  reales: 10,
  #  onzas: 14,
  #  granos: 50
  # }

  serialize :extra_info

  #
  # Associations
  #

  belongs_to :goldomable, polymorphic: true

  #
  # Scopes
  #

  scope :by_type, ->(type) { joins("JOIN #{ type.table_name } ON #{ type.table_name }.id = #{ GoldBatch.table_name }.goldomable_id AND #{ GoldBatch.table_name }.goldomable_type = '#{ type.to_s }'") }
  scope :by_goldomable_id, ->(goldomable_ids) { where(goldomable_id: goldomable_ids) }
  scope :available, -> { where(sold: false) }
  scope :sold, -> { where(sold: false) }

  #
  # Instance Methods
  #

  def extra_data
    OpenStruct.new(extra_info)
  end

  def grams
    extra_data.grams
  end

  def castellanos
    extra_data.castellanos
  end

  def tomines
    extra_data.tomines
  end

  def onzas
    extra_data.onzas
  end

  def reales
    extra_data.reales
  end

  def granos
    entra_data.granos
  end

  def grams?
    grams.present? && !grams.zero?
  end

  def castellanos?
    castellanos.present? && !castellanos.zero?
  end

  def tomines?
    tomines.present? && !tomines.zero?
  end

  def onzas?
    onzas.present? && !onzas.zero?
  end

  def reales?
    reales.present? && !reales.zero?
  end

  def granos?
    granos.present? && !granos.zero?
  end
end
