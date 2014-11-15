angular.module 'starter'

# HeaderCtrl
.controller 'HeaderCtrl', ['$location', 'Flash', 'User', ($location, Flash, User) ->
  @logout = ->
    User.logout()
    Flash.flash('You have successfully logged out.', 'success')
    $location.path('/')

  # Make sure CoffeeScript always returns this
  @
]
