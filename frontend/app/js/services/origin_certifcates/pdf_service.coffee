#
# This service is in charge to request the server  to create PDFs
#
# TODO: this service will be disabled untill is needed the OriginCertifications feature again.
# angular.module('app').factory 'PdfService', ($http)->
#   service=
#     #
#     # Barequero chatarrero  OC
#     createBarequeroChatarreroOriginCertificate: (origin_certificate)->
#       $http.post('/api/v1/files/download_b_c_report/',
#         {origin_certificate: origin_certificate},
#         headers: 'Content-type': 'application/pdf'
#         responseType: 'arraybuffer'
#         transformResponse = (data) ->
#           pdf = undefined
#           if data
#             pdf = new Blob([ data ], type: 'application/pdf')
#           { response: pdf }
#         )
#       .success (response) ->
#           sessionStorage.barequeroOriginCertificateService = []
#           file = new Blob([ response ], type: 'application/pdf')
#           fileURL = URL.createObjectURL(file)
#           window.open(fileURL, '_blank', '')

#     #
#     # Beneficiation Plant OC
#     createBeficiationPlantOriginCertificate: (origin_certificate)->
#       $http.post('/api/v1/files/download_p_b_report/',
#         {origin_certificate: origin_certificate},
#         headers: 'Content-type': 'application/pdf'
#         responseType: 'arraybuffer'
#         transformResponse = (data) ->
#           pdf = undefined
#           if data
#             pdf = new Blob([ data ], type: 'application/pdf')
#           { response: pdf }
#         )
#       .success (response) ->
#           sessionStorage.beneficiationPlantOriginCertificate = []
#           file = new Blob([ response ], type: 'application/pdf')
#           fileURL = URL.createObjectURL(file)
#           window.open(fileURL, '_blank', '')

#     #
#     # Houses Buy Sell  OC
#     createPawnshopsOriginCertificate: (origin_certificate)->
#       $http.post('/api/v1/files/download_c_c_report/',
#         {origin_certificate: origin_certificate},
#         headers: 'Content-type': 'application/pdf'
#         responseType: 'arraybuffer'
#         transformResponse = (data) ->
#           pdf = undefined
#           if data
#             pdf = new Blob([ data ], type: 'application/pdf')
#           { response: pdf }
#         )
#       .success (response) ->
#           sessionStorage.housesBuySellOriginCertificate = []
#           file = new Blob([ response ], type: 'application/pdf')
#           fileURL = URL.createObjectURL(file)
#           window.open(fileURL, '_blank', '')

#     #
#     # Authorized Miner OC
#     createAutorizedMinerOriginCertificate: (origin_certificate)->
#       $http.post('/api/v1/files/download_e_m_certificate/',
#         {origin_certificate: origin_certificate},
#         headers: 'Content-type': 'application/pdf'
#         responseType: 'arraybuffer'
#         transformResponse = (data) ->
#           pdf = undefined
#           if data
#             pdf = new Blob([ data ], type: 'application/pdf')
#           { response: pdf }
#         )
#       .success (response) ->
#           sessionStorage.authorizedMinerOriginCertificate =[]
#           file = new Blob([ response ], type: 'application/pdf')
#           fileURL = URL.createObjectURL(file)
#           window.open(fileURL, '_blank', '')
#   service