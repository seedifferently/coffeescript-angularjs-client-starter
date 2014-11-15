angular.module 'starter'

# AppCtrl
.controller 'AppCtrl', ['$scope', '$rootScope', '$location', 'Auth', 'Flash', ($scope, $rootScope, $location, Auth, Flash) ->
  @isAuthenticated = Auth.isAuthenticated
  @isAuthorized = Auth.isAuthorized
  @currentUser = Auth.currentUser
  @currentPath = ->
    $location.path()

  $scope.flashClass = "alert-#{Flash.level}"
  $scope.flashMessage = Flash.message

  # Event handlers
  $rootScope.$on 'flash:message', (_, level, message) ->
    $scope.flashClass = "alert-#{level}"
    $scope.flashMessage = message
    Flash.cleanup()

  $rootScope.$on 'flash:clear', ->
    $scope.flashMessage = ''
    Flash.cleanup()

  # Make sure CoffeeScript always returns this
  @
]
