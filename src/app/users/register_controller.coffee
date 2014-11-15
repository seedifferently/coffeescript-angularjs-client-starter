angular.module 'starter'

.controller 'RegisterCtrl', ['$location', 'Flash', 'User', ($location, Flash, User) ->
  # Register form submit
  @submit = (form) ->
    # Prepare the POST data
    data =
      email: @email
      password: @password
      confirm: @confirm
      profile: @profile

    # Register
    User.register(data).then -> # SUCCESS
      # Flash
      Flash.flash('Welcome to Starter.', 'success')

      # Redirect
      $location.path('/')
    , (errors) -> # FAILURE
      # Parse profile errors
      if errors['profile']
        errors['profile_first_name'] = errors['profile']
        errors['profile_last_name'] = errors['profile']
        delete errors['profile']

      # Set form API errors
      form.parseApiErrors(errors)

  # Make sure CoffeeScript always returns this
  @
]
