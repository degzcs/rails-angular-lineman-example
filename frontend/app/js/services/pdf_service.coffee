#
# This service is in charge to request the server  to create PDFs
#
angular.module('app').factory 'PdfService', ($http)->
  service=
    createPurchaseInvoice: (purchase, provider, goldBatch)->
      $http.post('/api/v1/files/download_purchase_report/perro=dog',
        {purchase: purchase , provider: provider, gold_batch: goldBatch},
        headers: 'Content-type': 'application/pdf',
        responseType: 'arraybuffer').success (response) ->
          file = new Blob([ response ], type: 'application/pdf')
          fileURL = URL.createObjectURL(file)
  service