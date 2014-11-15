angular.module 'starter'

.controller 'LoginCtrl', ['$location', 'Auth', 'Flash', 'User', ($location, Auth, Flash, User) ->
  # Redirect to root if already logged in
  if Auth.isAuthenticated()
    Flash.flash('You are already logged in.')
    $location.path('/')

  # Login form submit
  @submit = (form) ->
    # Login
    User.login({email: @email, password: @password}).then -> # SUCCESS
      # Flash
      Flash.flash('You have successfully logged in.', 'success')

      # Redirect
      $location.path(Auth.next)
    , (errors) -> # FAILURE
      # Set form API errors
      form.parseApiErrors(errors)

  # Make sure CoffeeScript always returns this
  @
]
