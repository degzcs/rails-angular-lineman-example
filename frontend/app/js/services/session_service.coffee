#
# This service is in charge to manage the request to the server for the session and password recovery
#
angular.module('app').factory( 'SessionService', ($resource, $http, $q, $location)->

  service =
    # $resource '/api/v1/session/:id', {}, {
    #   query: {method:'GET', isArray:false}
    #   }
    can_updated_password: false

    #
    # HTTP requests
    #

    forgotPassword: (email) ->
      $http.post('/api/v1/auth/forgot_password/',
        {email: email}
        )
      .success (response) ->
        console.log response

    canChangePassword: (email, token) ->
      $http.get( '/api/v1/auth/confirmation/',
        params:
          email: email
          token: token
      )
      .success (response) ->
        can_updated_password =  true
        console.log 'yay!'
      .error ->
        can_updated_password =  false
        console.log 'fail!'

    resetPassword: (email, password, password_confirmation)->
      $http.post '/api/v1/auth/change_password',
        email: email
        password: password
        password_confirmation: password_confirmation
      .success (response) ->
        console.log 'password changed'
      .error ->
        console.log 'errors!'

  #
  # Return service
  #

  service
)