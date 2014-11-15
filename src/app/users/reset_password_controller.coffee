angular.module 'starter'

.controller 'ResetPasswordCtrl', ['$location', 'Flash', 'User', ($location, Flash, User) ->
  @token = $location.search()['token']
  @email = $location.search()['email']

  # Reset password form submit
  @submit = (form) ->
    # Prepare the POST data
    data =
      token: @token
      email: @email
      password: @password
      confirm: @confirm

    # Call the API
    User.resetPassword(data).then -> # SUCCESS
      Flash.flash('Your password was successfully changed.', 'info')
      $location.path('/users/login.html').search({})
    , (errors) -> # FAILURE
      # Set form API errors
      form.parseApiErrors(errors)

  # Make sure CoffeeScript always returns this
  @
]
