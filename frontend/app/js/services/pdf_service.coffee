#
# This service is in charge to request the server  to create PDFs
#
angular.module('app').factory 'PdfService', ($http)->
  service=
    createPurchaseInvoice: (purchase, provider, goldBatch, buyer)->
      $http.post('/api/v1/files/download_purchase_report/',
        {purchase: purchase , provider: provider, gold_batch: goldBatch, purchaser: buyer},
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

    createBarequeroChatarreroOriginCertificate: (origin_certificate)->
      $http.post('/api/v1/files/download_b_c_report/',
        {origin_certificate: origin_certificate},
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