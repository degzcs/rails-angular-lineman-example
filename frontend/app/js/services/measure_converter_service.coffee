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
    realesToGrams: (reales)->
      (reales*4.6)/16

    #
    # Convert from Granos to Grams
    # e.g.  96 GRANOS -> 1 castellano -> 4.6 grams
    # @params granos [Integer]
    # @return [Float]
    #
    granosToGrams: (granos)->
      (granos*4.6)/96

    #
    # Get the Unit price for castellanos from the gram unit price
    # @params fineGramUnitPrice [Integer]
    # @return [Integer]
    #
    castellanosUnitPriceFrom: (fineGramUnitPrice)->
      (4.6*fineGramUnitPrice)

    #
    # Get the Unit price for Ounces from the gram unit price
    # @params fineGramUnitPrice [Integer]
    # @return [Integer]
    #
    ozsUnitPriceFrom: (fineGramUnitPrice)->
      31.1035*fineGramUnitPrice

    #
    # Get the Unit price for tomines from the gram unit price
    # @params fineGramUnitPrice [Integer]
    # @return [Integer]
    #
    tominesUnitPriceFrom: (fineGramUnitPrice)->
      (4.6*fineGramUnitPrice)/8

    #
    # Get the Unit price for riales from the gram unit price
    # @params fineGramUnitPrice [Integer]
    # @return [Integer]
    #
    realesUnitPriceFrom: (fineGramUnitPrice)->
      (4.6*fineGramUnitPrice)/16

    #
    # Get the Unit price for granos from the gram unit price
    # @params fineGramUnitPrice [Integer]
    # @return [Integer]
    #
    granosUnitPriceFrom: (fineGramUnitPrice)->
      (4.6*fineGramUnitPrice)/96

    #
    # Get the Unit price per gram from the fine gram unit price
    # @params fineGramUnitPrice [Integer]
    # @return [Integer]
    #
    gramsUnitPriceFrom: (fineGramUnitPrice)->
      '??'

    #
    # Fine-Grams to Real-Grams
    #
    gramsToFineGrams: (grams, grade)->
      (grams*grade)/999

    #
    #
    #
    fineGramsToGrams: (fine_grams, grade)->
        (999*fine_grams)/grade




  #
  # Return
  #
  service