angular.module 'starter'

.factory 'Flash', ['$rootScope', '$timeout', ($rootScope, $timeout) ->
  svc = {}

  svc.level = 'info'
  svc.message = ''
  svc.reset = undefined

  svc.cleanup = ->
    $timeout.cancel(svc.reset);
    svc.reset = $timeout ->
      svc.message = ''

  svc.emit = ->
    $rootScope.$emit 'flash:message', svc.level, svc.message

  svc.flash = (message, level = 'info') ->
    svc.level = level
    svc.message = message
    svc.emit()

  svc.clear = (level = svc.level) ->
    if svc.level == level
      svc.message = ''
      $rootScope.$emit 'flash:clear'

  $rootScope.$on '$locationChangeSuccess', svc.emit

  # Make sure CoffeeScript always returns this
  svc
]
