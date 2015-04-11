#
# This service is in charge to Convert all possibles gold measures to grams
#
angular.module('app').factory 'MeasureConverterService', ()->
  service=
    #
    # Convert from castellanos to Grams
    # e.g. 1 catellanos -> 4.6 grams
    # @params castellanos [Integer]
    # @return [Float]
    #
    castellanosToGrams: (catellanos)->
      catellanos*4.6

    #
    # Convert from Ounces to Grams
    # e.g. 1 Ounce -> 31.1035 grams
    # @params ozs [Integer]
    # @return [Float]
    #
    ozsToGrams: (ozs)->
      ozs*31.1035

    #
    # Convert from Tomines to Grams
    # e.g. 8 tomines -> 1 catellano -> 4.6 grams
    # @params tomines [Integer]
    # @return [Float]
    #
    tominesToGrams: (tomines)->
      (tomines*4.6)/8

    #
    # Convert from Riales to Grams
    # e.g. 16 riales -> 1 catellano -> 4.6 grams
    # @params riales [Integer]
    # @return [Float]
    #
    rialesToGrams: (riales)->
      (riales*4.6)/16

    #
    # Get the Unit price for castellanos from the gram unit price
    # @params gramUnitPrice [Integer]
    # @return [Integer]
    #
    castellanosUnitPriceFrom: (gramUnitPrice)->
      (4.6*gramUnitPrice)

    #
    # Get the Unit price for Ounces from the gram unit price
    # @params gramUnitPrice [Integer]
    # @return [Integer]
    #
    ozsUnitPriceFrom: (gramUnitPrice)->
      31.1035*gramUnitPrice

    #
    # Get the Unit price for tomines from the gram unit price
    # @params gramUnitPrice [Integer]
    # @return [Integer]
    #
    tominesUnitPriceFrom: (gramUnitPrice)->
      (4.6*gramUnitPrice)/8

    #
    # Get the Unit price for riales from the gram unit price
    # @params gramUnitPrice [Integer]
    # @return [Integer]
    #
    rialesUnitPriceFrom: (gramUnitPrice)->
      (4.6*gramUnitPrice)/16

    #
    # Fine-Grams to Real-Grams
    #
    gramsToFineGrams: (grams, law)->
      (grams*law)/999

  #
  # Return
  #
  service