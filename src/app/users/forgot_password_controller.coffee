angular.module 'starter'

.controller 'ForgotPasswordCtrl', ['Flash', 'User', (Flash, User) ->
  # Forgot password form submit
  @submit = (form) ->
    # Call the API
    User.forgotPassword({email: @email}).then -> # SUCCESS
      Flash.flash('Password reset link has been emailed to you.', 'info')
    , (errors) -> # FAILURE
      # Set form API errors
      form.parseApiErrors(errors)

  # Make sure CoffeeScript always returns this
  @
]
