'use strict'

# Starter module config
angular.module 'starter', [
  'ngRoute'
  'base64'
  'LocalStorageModule'
  'restangular'
]


# Routes config
.config ['$routeProvider', ($routeProvider) ->
  # Root - /
  $routeProvider.when '/',
    templateUrl: 'tmpl/root/index.html'
    controller: 'RootCtrl'
    controllerAs: 'root'

  $routeProvider.when '/about.html',
    templateUrl: 'tmpl/root/about.html'
    controller: 'RootCtrl'
    controllerAs: 'root'

  # Users - /users/
  $routeProvider.when '/users/login.html',
    templateUrl: 'tmpl/users/login.html'
    controller: 'LoginCtrl'
    controllerAs: 'login'

  $routeProvider.when '/users/register.html',
    templateUrl: 'tmpl/users/register.html'
    controller: 'RegisterCtrl'
    controllerAs: 'register'

  $routeProvider.when '/users/forgot_password.html',
    templateUrl: 'tmpl/users/forgot_password.html'
    controller: 'ForgotPasswordCtrl'
    controllerAs: 'forgotPassword'

  $routeProvider.when '/users/reset_password.html',
    templateUrl: 'tmpl/users/reset_password.html'
    controller: 'ResetPasswordCtrl'
    controllerAs: 'resetPassword'

  $routeProvider.when '/users/me.html',
    templateUrl: 'tmpl/users/me.html'
    controller: 'UsersCtrl'
    controllerAs: 'users'
    resolve:
      acl: (Auth) ->
        return Auth.resolveAcl(Auth.ACL.user)

  # Admin - /admin/
  $routeProvider.when '/admin/',
    templateUrl: 'tmpl/admin/index.html'
    controller: 'AdminCtrl'
    controllerAs: 'admin'
    resolve:
      acl: (Auth) ->
        return Auth.resolveAcl(Auth.ACL.admin)

  $routeProvider.otherwise redirectTo: '/'
]


# LocalStorage config
.config ['localStorageServiceProvider', (localStorageServiceProvider) ->
  localStorageServiceProvider.setPrefix('starter')
]


# Restangular configs
.config ['RestangularProvider', '$base64', (RestangularProvider, $base64) ->
  # Set API baseurl
  RestangularProvider.setBaseUrl('http://localhost:6543/api')

  # Send auth token if user record is present, show "loading" modal during request
  RestangularProvider.addFullRequestInterceptor (element, operation, what, url, headers, params, httpConfig) ->
    angular.element(document.querySelector('#progress-modal')).modal('show')

    user = window.localStorage['starter.user']
    user = if user then angular.fromJson($base64.decode(user)) else {}

    if user.authorization_token
      headers ?= {}
      headers.Authorization = "Token #{user.authorization_token}"

    return element

  # Define response object structure, hide "loading" modal
  RestangularProvider.addResponseInterceptor (data, operation, what, url, response, deferred) ->
    extractedData = data['data']

    if angular.isObject(extractedData)
      extractedData.meta = data['meta']
      extractedData.errors = data['errors']

    angular.element(document.querySelector('#progress-modal')).modal('hide')

    return extractedData

  # Handle Restangular errors
  RestangularProvider.setErrorInterceptor (response, deferred, responseHandler) ->
    angular.element(document.querySelector('#progress-modal')).modal('hide')

    console.error "Server returned status: #{response.status}"
]
