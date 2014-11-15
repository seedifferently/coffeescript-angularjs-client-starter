angular.module 'starter'

.factory 'User', ['$q', '$rootScope', '$location', 'Restangular', 'Auth', ($q, $rootScope, $location, Restangular, Auth) ->
  svc = {}

  # Restangular helpers
  svc.one = Restangular.service('users').one
  svc.all = Restangular.service('users').all

  # Auth helpers
  svc.current = ->
    Auth.currentUser()

  # Login method
  svc.login = (data) ->
    deferred = $q.defer()

    # Call the API
    svc.one().post('login', data).then (data) -> # SUCCESS
      deferred.resolve()

      # Set the user object
      Auth.setUser(data)
      $rootScope.$broadcast(Auth.EVENTS.loginSuccess)
    , (response) -> # FAILURE
      deferred.reject(response.data.errors)
      $rootScope.$broadcast(Auth.EVENTS.loginFailed)

    return deferred.promise

  # Logout method
  svc.logout = Auth.clear

  # Register method
  svc.register = (data) ->
    deferred = $q.defer()

    # Call the API
    svc.one().post('register', data).then (data) -> # SUCCESS
      deferred.resolve()

      # Set the user object
      Auth.setUser(data)
      $rootScope.$broadcast(Auth.EVENTS.loginSuccess)
    , (response) -> # FAILURE
      deferred.reject(response.data.errors)

    return deferred.promise

  # Forgot password method
  svc.forgotPassword = (data) ->
    deferred = $q.defer()

    # Call the API
    svc.one().post('forgot_password', data).then (data) -> # SUCCESS
      deferred.resolve()
    , (response) -> # FAILURE
      deferred.reject(response.data.errors)

    return deferred.promise

  # Reset password method
  svc.resetPassword = (data) ->
    deferred = $q.defer()

    # Call the API
    svc.one().post('reset_password', data).then (data) -> # SUCCESS
      deferred.resolve()
    , (response) -> # FAILURE
      deferred.reject(response.data.errors)

    return deferred.promise

  # Make sure CoffeeScript always returns this
  svc
]
