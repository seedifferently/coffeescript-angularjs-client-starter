angular.module 'starter'

.factory 'Auth', ['$rootScope', '$q', '$location', '$cacheFactory', '$base64', 'Restangular', 'localStorageService', 'Flash', ($rootScope, $q, $location, $cacheFactory, $base64, Restangular, localStorageService, Flash) ->
  svc = {}

  svc.next = '/'

  svc.EVENTS =
    loginSuccess: 'auth-login-success'
    loginFailed: 'auth-login-failed'
    logoutSuccess: 'auth-logout-success'
    notAuthenticated: 'auth-not-authenticated'
    notAuthorized: 'auth-not-authorized'
    authenticated: 'auth-authenticated'
    authorized: 'auth-authorized'

  svc.ACL =
    admin: ['admin']
    superuser: ['admin', 'superuser']
    user: ['admin', 'superuser', 'user']

  svc.setUser = (data) ->
    # Set/store the user object from supplied user data
    user =
      id: data.id
      full_name: "#{data.profile.first_name} #{data.profile.last_name}"
      email: data.email
      role: data.role
      api_token: data.api_token
      last_login: data.last_login
      authorization_token: $base64.encode("#{data.email}:#{data.api_token}")

    localStorageService.set('user', $base64.encode(angular.toJson(user)))

  svc.currentUser = ->
    user = localStorageService.get('user')
    user = if user then angular.fromJson($base64.decode(user)) else {}

    return user

  svc.isAuthenticated = ->
    user = svc.currentUser()

    return !!user['authorization_token']

  svc.isAuthorized = (authorizedRoles) ->
    if !angular.isArray(authorizedRoles)
      authorizedRoles = [authorizedRoles]

    return !!(svc.isAuthenticated() and authorizedRoles.indexOf(svc.currentUser().role) isnt -1)

  svc.resolveAcl = (acl) ->
    deferred = $q.defer()
    next = $location.path()

    if !svc.isAuthorized(acl)
        if svc.isAuthenticated()
          # user is not authorized
          deferred.reject(svc.EVENTS.notAuthorized)
          $rootScope.$broadcast(svc.EVENTS.notAuthorized)
          Flash.flash('You are not authorized to access that location.', 'warning')

          $location.path('/users/me.html').replace()
        else
          # user is not logged in
          deferred.reject(svc.EVENTS.notAuthenticated)
          $rootScope.$broadcast(svc.EVENTS.notAuthenticated)
          Flash.flash('Please log in before continuing.', 'warning')

          # Redirect to login
          svc.next = next
          $location.path('/users/login.html').replace()
    else
      deferred.resolve(svc.EVENTS.authorized)

    return deferred.promise

  svc.clear = ->
    $cacheFactory.get('$http').removeAll()
    localStorageService.remove('user')

  # Make sure CoffeeScript always returns this
  svc
]
