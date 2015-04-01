#
# This service is in charge to manage the server requests related to Purchases
#
#TODO: make the remaining HTTP requests
angular.module('app').factory('PurchaseService', ($upload)->
   create= (purchase) ->
      if purchase.origin_certificate_file and purchase.origin_certificate_file.length
        i = 0
        while i < purchase.origin_certificate_file.length
          file = purchase.origin_certificate_file[i]
          $upload.upload(
            url: '/api/v1/purchases/'
            method: 'POST'
            fields:
              "purchase[amount]": purchase.amount,
              "purchase[provider_id]": purchase.provider_id
              "purchase[gold_batch_id]": purchase.gold_batch_id
              "purchase[origin_certificate_sequence]": purchase.origin_certificate_sequence
            file: file
            fileFormDataName: 'purchase[origin_certificate_file]')

          .progress((evt) ->
              progressPercentage = parseInt(100.0 * evt.loaded / evt.total)
              console.log 'progress: ' + progressPercentage + '% ' + evt.config.file.name
          )

          .success (data, status, headers, config) ->
              console.log 'file ' + config.file.name + 'uploaded. Response: ' + data
          i++
   return { create: create }
)
