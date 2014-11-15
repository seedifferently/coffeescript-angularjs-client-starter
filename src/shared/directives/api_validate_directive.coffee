angular.module 'starter'

# Parse form errors based on API response errors
.directive 'apiValidate', ['Flash', (Flash) ->
  dir = {}

  dir.restrict = 'A'
  dir.require = '^form'

  dir.link = (scope, element, attrs, form) ->
    element.on 'submit', (event) ->
      # Clean up any prior form errors
      Flash.clear('danger')

      _.each angular.copy(form.$error['message']), (error) ->
        form[error.$name].$setPristine()
        form[error.$name].$setValidity('message', true)

    # Update the form with errors from the API
    form.parseApiErrors = (errors) ->
      # Parse "global" errors
      if errors['_global']
        Flash.flash(errors['_global'], 'danger')
        delete errors['_global']

      # Parse remaining errors
      _.each errors, (error, name) ->
        name = name.replace(/\./g, '_') # Sanitize nested form object errors

        if form[name]
          form[name].$dirty = true
          form[name].$setValidity('message', false)
          form[name].$error.message = error
        else
          console.warn "Could not parse the following error for #{name}: #{error}"

    # Form error helpers
    form.hasError = (name) ->
      !!(form[name] and form[name].$dirty and form[name].$invalid)

    form.hasErrorMessage = (name) ->
      !!(form[name] and form[name].$error and form[name].$error['message'])

  # Make sure CoffeeScript always returns this
  return dir
]
