describe 'Users E2E Tests', ->

  describe 'Login', ->
    beforeEach ->
      browser.get '#/users/login.html'

    it 'should show form', ->
      expect(browser.getTitle()).toEqual 'Starter'
      expect(element(By.css('.page-header h1')).getText()).toEqual 'Login'
      expect(element(By.model('login.email')).isPresent()).toBe true
      expect(element(By.model('login.password')).isPresent()).toBe true
      expect(element(By.buttonText('Login')).isPresent()).toBe true

      # Login nav link shouldn't be shown
      expect(element(By.linkText('Login')).isPresent()).toBe false

    it 'should show form errors', ->
      # Submit blank form
      element(By.buttonText('Login')).click()
      expect(element(By.css('form .form-group.has-error.email .help-block')).getText()).toEqual 'Please enter an email address'
      expect(element(By.css('form .form-group.has-error.password .help-block')).getText()).toEqual 'Please enter a value'

      # Submit invalid password
      element(By.model('login.email')).sendKeys 'user@example.com'
      element(By.model('login.password')).sendKeys 'test'
      element(By.buttonText('Login')).click()
      expect(element(By.css('form .form-group.has-error')).isPresent()).toBe false
      expect(element(By.css('#flash-message.alert-danger')).getText()).toEqual 'Invalid email or password.'
      element(By.model('login.email')).clear()
      element(By.model('login.password')).clear()

      # Submit malformed email
      element(By.model('login.email')).sendKeys 'test@test'
      element(By.buttonText('Login')).click()
      expect(element(By.css('form .form-group.has-error.email .help-block')).getText()).toEqual 'The domain portion of the email address is invalid (the portion after the @: test)'
      expect(element(By.css('form .form-group.has-error.password .help-block')).getText()).toEqual 'Please enter a value'
      # Make sure the flash error message was cleared
      expect(element(By.css('#flash-message.alert-danger')).isPresent()).toBe false


    it 'should be successful with valid data', ->
      # Log in
      element(By.model('login.email')).sendKeys 'user@example.com'
      element(By.model('login.password')).sendKeys 'user'
      element(By.buttonText('Login')).click()

      # Verify redirect and flash
      expect(browser.getCurrentUrl()).toMatch '#/$'
      expect(browser.getTitle()).toEqual('Starter')
      expect(element(By.css('#flash-message.alert-success')).getText()).toEqual 'You have successfully logged in.'

      # Verify user info
      element(By.linkText('user@example.com')).click()
      expect(browser.getCurrentUrl()).toMatch '#/users/me.html$'
      expect(element(By.css('.page-header h1')).getText()).toEqual 'John Smith'
      expect(element(By.css('dl')).getText()).toContain 'Email:\nuser@example.com'
      expect(element(By.css('dl')).getText()).toContain 'Role:\nuser'

      # Log out
      element(By.linkText('Logout')).click()

    it 'should redirect and flash if already logged in', ->
      # Log in
      element(By.model('login.email')).sendKeys 'user@example.com'
      element(By.model('login.password')).sendKeys 'user'
      element(By.buttonText('Login')).click()

      # Verify redirect and flash
      expect(browser.getCurrentUrl()).toMatch '#/$'

      # Re-visit login page, verify redirect and flash
      browser.get '#/users/login.html'
      expect(browser.getCurrentUrl()).toMatch '#/$'
      expect(browser.getTitle()).toEqual('Starter')
      expect(element(By.css('#flash-message.alert-info')).getText()).toEqual 'You are already logged in.'

      # Log out
      element(By.linkText('Logout')).click()

  describe 'Logout', ->
    beforeEach ->
      # Log in
      browser.get '#/users/login.html'
      element(By.model('login.email')).sendKeys 'user@example.com'
      element(By.model('login.password')).sendKeys 'user'
      element(By.buttonText('Login')).click()

      # Verify redirect and flash
      expect(browser.getCurrentUrl()).toMatch '#/$'

    it 'should log out', ->
      # Visit user info page
      element(By.linkText('user@example.com')).click()
      expect(browser.getCurrentUrl()).toMatch '#/users/me.html$'

      # Log out
      element(By.linkText('Logout')).click()
      expect(browser.getCurrentUrl()).toMatch '#/$'
      expect(element(By.css('#flash-message.alert-success')).getText()).toEqual 'You have successfully logged out.'

      # Login nav link should be shown
      expect(element(By.linkText('Login')).isPresent()).toBe true

  describe 'Register', ->
    beforeEach ->
      browser.get '#/users/register.html'

    it 'should show form', ->
      expect(browser.getTitle()).toEqual 'Starter'
      expect(element(By.css('.page-header h1')).getText()).toEqual 'Register'
      expect(element(By.model('register.profile.first_name')).isPresent()).toBe true
      expect(element(By.model('register.profile.last_name')).isPresent()).toBe true
      expect(element(By.model('register.email')).isPresent()).toBe true
      expect(element(By.model('register.password')).isPresent()).toBe true
      expect(element(By.model('register.confirm')).isPresent()).toBe true
      expect(element(By.buttonText('Register')).isPresent()).toBe true

    it 'should show form errors', ->
      # Submit blank form
      element(By.buttonText('Register')).click()
      expect(element(By.css('form .form-group.has-error.profile_first_name .help-block')).getText()).toEqual 'Missing value'
      expect(element(By.css('form .form-group.has-error.profile_last_name .help-block')).getText()).toEqual 'Missing value'
      expect(element(By.css('form .form-group.has-error.email .help-block')).getText()).toEqual 'Missing value'
      expect(element(By.css('form .form-group.has-error.password .help-block')).getText()).toEqual 'Missing value'
      expect(element(By.css('form .form-group.has-error.confirm .help-block')).getText()).toEqual 'Missing value'

      # Submit malformed email
      element(By.model('register.email')).sendKeys 'test@test'
      element(By.buttonText('Register')).click()
      expect(element(By.css('form .form-group.has-error.email .help-block')).getText()).toEqual 'The domain portion of the email address is invalid (the portion after the @: test)'
      element(By.model('register.email')).clear()

      # Submit invalid password
      element(By.model('register.password')).sendKeys 'test'
      element(By.buttonText('Register')).click()
      expect(element(By.css('form .form-group.has-error.password .help-block')).getText()).toEqual 'Enter a value 6 characters long or more'
      element(By.model('register.password')).clear()

      # Submit invalid password
      element(By.model('register.password')).sendKeys 'test'
      element(By.buttonText('Register')).click()
      expect(element(By.css('form .form-group.has-error.password .help-block')).getText()).toEqual 'Enter a value 6 characters long or more'
      element(By.model('register.password')).clear()

      # Submit non-matching password
      element(By.model('register.password')).sendKeys 'testing1'
      element(By.model('register.confirm')).sendKeys 'testing2'
      element(By.buttonText('Register')).click()
      expect(element(By.css('form .form-group.has-error.password')).isPresent()).toBe false
      expect(element(By.css('form .form-group.has-error.confirm .help-block')).getText()).toEqual 'Fields do not match'
      element(By.model('register.password')).clear()
      element(By.model('register.confirm')).clear()

      # Submit duplicate email
      element(By.model('register.profile.first_name')).sendKeys 'First'
      element(By.model('register.profile.last_name')).sendKeys 'Last'
      element(By.model('register.email')).sendKeys 'user@example.com'
      element(By.model('register.password')).sendKeys 'testing'
      element(By.model('register.confirm')).sendKeys 'testing'
      element(By.buttonText('Register')).click()
      expect(element(By.css('form .form-group.has-error.email .help-block')).getText()).toEqual 'Email address is already registered'

    it 'should be successful with valid data', ->
      # Register
      element(By.model('register.profile.first_name')).sendKeys 'First'
      element(By.model('register.profile.last_name')).sendKeys 'Last'
      element(By.model('register.email')).sendKeys 'test-register@example.com'
      element(By.model('register.password')).sendKeys 'testing'
      element(By.model('register.confirm')).sendKeys 'testing'
      element(By.buttonText('Register')).click()

      # Verify redirect and flash
      expect(browser.getCurrentUrl()).toMatch '#/$'
      expect(browser.getTitle()).toEqual('Starter')
      expect(element(By.css('#flash-message.alert-success')).getText()).toEqual 'Welcome to Starter.'

      # Verify user info
      element(By.linkText('test-register@example.com')).click()
      expect(browser.getCurrentUrl()).toMatch '#/users/me.html$'
      expect(element(By.css('.page-header h1')).getText()).toEqual 'First Last'
      expect(element(By.css('dl')).getText()).toContain 'Email:\ntest-register@example.com'
      expect(element(By.css('dl')).getText()).toContain 'Role:\nuser'

      # Log out
      element(By.linkText('Logout')).click()

  describe 'Forgot Password', ->
    beforeEach ->
      browser.get '#/users/forgot_password.html'

    it 'should show form', ->
      expect(browser.getTitle()).toEqual 'Starter'
      expect(element(By.css('.page-header h1')).getText()).toEqual 'Forgot Password'
      expect(element(By.model('forgotPassword.email')).isPresent()).toBe true
      expect(element(By.buttonText('Submit')).isPresent()).toBe true

    it 'should show form errors', ->
      # Submit blank form
      element(By.buttonText('Submit')).click()
      expect(element(By.css('form .form-group.has-error.email .help-block')).getText()).toEqual 'Please enter an email address'

      # Submit malformed email
      element(By.model('forgotPassword.email')).sendKeys 'test@test'
      element(By.buttonText('Submit')).click()
      expect(element(By.css('form .form-group.has-error.email .help-block')).getText()).toEqual 'The domain portion of the email address is invalid (the portion after the @: test)'
      element(By.model('forgotPassword.email')).clear()

      # Submit invalid email
      element(By.model('forgotPassword.email')).sendKeys 'test-invalid@example.com'
      element(By.buttonText('Submit')).click()
      expect(element(By.css('form .form-group.has-error')).isPresent()).toBe false
      expect(element(By.css('#flash-message.alert-danger')).getText()).toEqual 'Invalid email address.'

    it 'should be successful with valid data', ->
      # Submit
      element(By.model('forgotPassword.email')).sendKeys 'user@example.com'
      element(By.buttonText('Submit')).click()

      # Verify submit and flash
      expect(element(By.css('form .form-group.has-error')).isPresent()).toBe false
      expect(element(By.css('#flash-message.alert-info')).getText()).toEqual 'Password reset link has been emailed to you.'

  describe 'Reset Password', ->
    beforeEach ->
      browser.get '#/users/reset_password.html'

    it 'should show form', ->
      expect(browser.getTitle()).toEqual 'Starter'
      expect(element(By.css('.page-header h1')).getText()).toEqual 'Reset Password'
      expect(element(By.model('resetPassword.token')).isPresent()).toBe true
      expect(element(By.model('resetPassword.email')).isPresent()).toBe true
      expect(element(By.model('resetPassword.password')).isPresent()).toBe true
      expect(element(By.model('resetPassword.confirm')).isPresent()).toBe true
      expect(element(By.buttonText('Reset Password')).isPresent()).toBe true

    it 'should show form errors', ->
      # Submit blank form
      element(By.buttonText('Reset Password')).click()
      expect(element(By.css('form .form-group.has-error.token .help-block')).getText()).toEqual 'Missing or invalid reset token.'
      expect(element(By.css('form .form-group.has-error.email .help-block')).getText()).toEqual 'Missing value'
      expect(element(By.css('form .form-group.has-error.password .help-block')).getText()).toEqual 'Missing value'
      expect(element(By.css('form .form-group.has-error.confirm .help-block')).getText()).toEqual 'Missing value'

      # Submit malformed email
      element(By.model('resetPassword.email')).sendKeys 'test@test'
      element(By.buttonText('Reset Password')).click()
      expect(element(By.css('form .form-group.has-error.email .help-block')).getText()).toEqual 'The domain portion of the email address is invalid (the portion after the @: test)'
      element(By.model('resetPassword.email')).clear()

      # Submit invalid password
      element(By.model('resetPassword.password')).sendKeys 'test'
      element(By.buttonText('Reset Password')).click()
      expect(element(By.css('form .form-group.has-error.password .help-block')).getText()).toEqual 'Enter a value 6 characters long or more'
      element(By.model('resetPassword.password')).clear()

      # Submit non-matching password
      element(By.model('resetPassword.password')).sendKeys 'testing1'
      element(By.model('resetPassword.confirm')).sendKeys 'testing2'
      element(By.buttonText('Reset Password')).click()
      expect(element(By.css('form .form-group.has-error.password')).isPresent()).toBe false
      expect(element(By.css('form .form-group.has-error.confirm .help-block')).getText()).toEqual 'Fields do not match'
      element(By.model('resetPassword.password')).clear()
      element(By.model('resetPassword.confirm')).clear()

      # Submit invalid token
      browser.get '#/users/reset_password.html?token=invalid'
      element(By.model('resetPassword.email')).sendKeys 'testing@example.com'
      element(By.model('resetPassword.password')).sendKeys 'testing'
      element(By.model('resetPassword.confirm')).sendKeys 'testing'
      element(By.buttonText('Reset Password')).click()
      expect(element(By.css('form .form-group.has-error')).isPresent()).toBe false
      expect(element(By.css('#flash-message.alert-danger')).getText()).toEqual 'Could not verify reset parameters.'

    it 'should be successful with valid data', ->
      browser.get '#/users/reset_password.html?token=testing'

      # Submit
      element(By.model('resetPassword.email')).sendKeys 'testing@example.com'
      element(By.model('resetPassword.password')).sendKeys 'testing'
      element(By.model('resetPassword.confirm')).sendKeys 'testing'
      element(By.buttonText('Reset Password')).click()

      # Verify redirect and flash
      expect(browser.getCurrentUrl()).toMatch '#/users/login.html$'
      expect(browser.getTitle()).toEqual('Starter')
      expect(element(By.css('#flash-message.alert-info')).getText()).toEqual 'Your password was successfully changed.'

      # Log in
      element(By.model('login.email')).sendKeys 'testing@example.com'
      element(By.model('login.password')).sendKeys 'testing'
      element(By.buttonText('Login')).click()

      # Verify redirect and flash
      expect(browser.getCurrentUrl()).toMatch '#/$'
      expect(browser.getTitle()).toEqual('Starter')
      expect(element(By.css('#flash-message.alert-success')).getText()).toEqual 'You have successfully logged in.'

      # Log out
      element(By.linkText('Logout')).click()
