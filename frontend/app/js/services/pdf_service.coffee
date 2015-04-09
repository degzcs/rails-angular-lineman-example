#
# This service is in charge to request the server  to create PDFs
#
angular.module('app').factory 'PdfService', ($http, $sce)->
  service=
    createPurchaseInvoice: (purchase, provider, goldBatch)->
      $http.post('/api/v1/files/download_purchase_report/',
        {purchase: purchase , provider: provider, gold_batch: goldBatch},
        headers: 'Content-type': 'application/pdf',
        responseType: 'arraybuffer').success (response) ->
          file = new Blob([ response ], type: 'application/pdf')
          saveAs(file, 'File_Name_With_Some_Unique_Id_Time' + '.pdf');
          console.log 'purchase pdf: ' +file
          fileURL = URL.createObjectURL(file)
          $sce.trustAsResourceUrl(fileURL);
  service