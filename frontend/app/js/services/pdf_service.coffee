#
# This service is in charge to request the server  to create PDFs
#
angular.module('app').factory 'PdfService', ($http, $sce)->
  service=
    createPurchaseInvoice: (purchase, provider, goldBatch)->
      $http.post('/api/v1/files/download_purchase_report/',
        {purchase: purchase , provider: provider, gold_batch: goldBatch},
        headers: 'Content-type': 'application/pdf'
        responseType: 'arraybuffer'
        transformResponse = (data) ->
          pdf = undefined
          if data
            pdf = new Blob([ data ], type: 'application/pdf')
          { response: pdf }
        )
      .success (response) ->
          file = new Blob([ response ], type: 'application/pdf')
          fileURL = URL.createObjectURL(file)
          window.open(fileURL, '_blank', '');
  service