#
# This service is in charge to request the server  to create PDFs
#
angular.module('app').factory 'PdfService', ($http)->
  service=
    createPurchaseInvoice: (purchase, provider, goldBatch)->
      $http.post  '/api/v1/files/download_purchase_report', {purchase: purchase , provider: provider, gold_batch: goldBatch}

  service