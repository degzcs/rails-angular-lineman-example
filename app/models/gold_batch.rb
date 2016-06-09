# == Schema Information
#
# Table name: gold_batches
#
#  id              :integer          not null, primary key
#  fine_grams      :float
#  grade           :integer
#  inventory_id    :integer
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
  # }

  serialize :extra_info

  #
  # Associations
  #

  belongs_to :goldomable, polymorphic: true

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

end
