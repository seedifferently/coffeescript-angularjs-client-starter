describe 'Users Unit Tests', ->
  beforeEach angular.mock.module('starter')

  formMock =
    $setPristine: ->
      true
    parseApiErrors: (errors) ->
      errors

  # Fixtures
  testUserData =
    id: 1
    email: 'test@example.com'
    role: 'user'
    api_token: 'arstneio'
    last_login: 'never'
    profile:
      first_name: 'First'
      last_name: 'Last'

  describe 'Routes', ->
    it 'should map Login routes to LoginCtrl', inject ($route) ->
      expect($route.routes['/users/login.html'].controller).toBe('LoginCtrl')
      expect($route.routes['/users/login.html'].templateUrl).toEqual('tmpl/users/login.html')

    it 'should map Register routes to RegisterCtrl', inject ($route) ->
      expect($route.routes['/users/register.html'].controller).toBe('RegisterCtrl')
      expect($route.routes['/users/register.html'].templateUrl).toEqual('tmpl/users/register.html')

    it 'should map Forgot Password routes to ForgotPasswordCtrl', inject ($route) ->
      expect($route.routes['/users/forgot_password.html'].controller).toBe('ForgotPasswordCtrl')
      expect($route.routes['/users/forgot_password.html'].templateUrl).toEqual('tmpl/users/forgot_password.html')

    it 'should map Reset Password routes to ResetPasswordCtrl', inject ($route) ->
      expect($route.routes['/users/reset_password.html'].controller).toBe('ResetPasswordCtrl')
      expect($route.routes['/users/reset_password.html'].templateUrl).toEqual('tmpl/users/reset_password.html')

    it 'should map Me routes to UsersCtrl', inject ($route) ->
      expect($route.routes['/users/me.html'].controller).toBe('UsersCtrl')
      expect($route.routes['/users/me.html'].templateUrl).toEqual('tmpl/users/me.html')

    it 'should resolve ACL for /users/me.html', inject ($route, _Auth_) ->
      auth = _Auth_

      # Unauthenticated
      expect($route.routes['/users/me.html'].resolve.acl(auth).$$state.status).toEqual 2
      expect($route.routes['/users/me.html'].resolve.acl(auth).$$state.value).toEqual 'auth-not-authenticated'

      # Authorized
      auth.setUser(testUserData)
      expect(auth.isAuthenticated()).toBe true
      expect($route.routes['/users/me.html'].resolve.acl(auth).$$state.status).toEqual 1
      expect($route.routes['/users/me.html'].resolve.acl(auth).$$state.value).toEqual 'auth-authorized'
      auth.clear()

  describe 'Controllers', ->
    describe 'UsersCtrl', ->
      it 'should be defined', inject ($rootScope, $controller) ->
        scope = $rootScope
        ctrl = $controller('UsersCtrl', {$scope: scope})

        expect(ctrl).toBeDefined()

    describe 'LoginCtrl', ->
      it 'should be defined', inject ($rootScope, $controller) ->
        scope = $rootScope
        ctrl = $controller('LoginCtrl', {$scope: scope})

        expect(ctrl).toBeDefined()

      it 'should redirect if already logged in', inject ($rootScope, $controller, $location, _Auth_, _Flash_) ->
        scope = $rootScope
        auth = _Auth_
        flash = _Flash_

        auth.setUser(testUserData)
        expect($location.path()).toEqual ''
        expect(flash.level).toEqual 'info'
        expect(flash.message).toEqual ''

        ctrl = $controller('LoginCtrl', {$scope: scope})

        expect($location.path()).toEqual '/'
        expect(flash.level).toEqual 'info'
        expect(flash.message).toEqual 'You are already logged in.'

        auth.clear()

      it 'should submit login', inject ($rootScope, $httpBackend, $controller, $location, _Auth_, _Flash_) ->
        scope = $rootScope
        http = $httpBackend
        ctrl = $controller('LoginCtrl', {$scope: scope})
        auth = _Auth_
        flash = _Flash_

        # Verify/set data
        expect(auth.currentUser()).toEqual {}
        expect($location.path()).toEqual ''
        expect(flash.level).toEqual 'info'
        expect(flash.message).toEqual ''
        data = {email: 'test@example.com', password: 'testing'}
        response = {"errors": {}, "data": {"id": 1, "profile": {"first_name": "First", "last_name": "Last"}, "role": "user", "email": "test@example.com", "api_token": "arstneio", "last_login": "never"}}
        auth.next = '/next'
        ctrl.email = data.email
        ctrl.password = data.password

        http.expectPOST('http://localhost:6543/api/users/login', data).respond(200, response)
        promise = ctrl.submit(formMock)
        data = promise.$object
        $rootScope.$digest()
        http.flush()

        # Verify data
        expect($location.path()).toEqual '/next'
        expect(flash.level).toEqual 'success'
        expect(flash.message).toEqual 'You have successfully logged in.'
        expect(auth.currentUser().email).toEqual 'test@example.com'

        auth.clear()

      it 'should return errors on invalid submit', inject ($rootScope, $httpBackend, $controller) ->
        scope = $rootScope
        http = $httpBackend
        ctrl = $controller('LoginCtrl', {$scope: scope})
        spyOn(formMock, 'parseApiErrors')

        data = {email: 'test@example.com', password: 'invalid'}
        response = {"errors": {"_global": "Invalid email or password."}, "data": null}
        ctrl.email = data.email
        ctrl.password = data.password

        http.expectPOST('http://localhost:6543/api/users/login', data).respond(422, response)
        promise = ctrl.submit(formMock)
        data = promise.$object
        $rootScope.$digest()
        http.flush()

        # Verify data
        expect(formMock.parseApiErrors).toHaveBeenCalledWith(response.errors)

    describe 'RegisterCtrl', ->
      it 'should be defined', inject ($rootScope, $controller) ->
        scope = $rootScope
        ctrl = $controller('RegisterCtrl', {$scope: scope})

        expect(ctrl).toBeDefined()

      it 'should submit register', inject ($rootScope, $httpBackend, $controller, $location, _Auth_, _Flash_) ->
        scope = $rootScope
        http = $httpBackend
        ctrl = $controller('RegisterCtrl', {$scope: scope})
        auth = _Auth_
        flash = _Flash_

        # Verify/set data
        expect(auth.currentUser()).toEqual {}
        expect($location.path()).toEqual ''
        expect(flash.level).toEqual 'info'
        expect(flash.message).toEqual ''
        data =
          email: 'test@example.com'
          password: 'testing'
          confirm: 'testing'
          profile:
            first_name: 'First'
            last_name: 'Last'
        response = {"errors": {}, "data": {"id": 1, "profile": {"first_name": "First", "last_name": "Last"}, "role": "user", "email": "test@example.com", "api_token": "arstneio", "last_login": "never"}}
        ctrl.email = data.email
        ctrl.password = data.password
        ctrl.confirm = data.confirm
        ctrl.profile = data.profile

        http.expectPOST('http://localhost:6543/api/users/register', data).respond(200, response)
        promise = ctrl.submit(formMock)
        data = promise.$object
        $rootScope.$digest()
        http.flush()

        # Verify data
        expect($location.path()).toEqual '/'
        expect(flash.level).toEqual 'success'
        expect(flash.message).toEqual 'Welcome to Starter.'
        expect(auth.currentUser().email).toEqual 'test@example.com'

        auth.clear()

      it 'should return errors on invalid submit', inject ($rootScope, $httpBackend, $controller) ->
        scope = $rootScope
        http = $httpBackend
        ctrl = $controller('RegisterCtrl', {$scope: scope})
        spyOn(formMock, 'parseApiErrors')

        data = {email: 'test@example.com', password: 'invalid'}
        response = {"errors": {"profile": "Missing value", "confirm": "Missing value", "password": "Enter a value 6 characters long or more"}, "data": null}
        ctrl.email = data.email
        ctrl.password = data.password

        http.expectPOST('http://localhost:6543/api/users/register', data).respond(422, response)
        promise = ctrl.submit(formMock)
        data = promise.$object
        $rootScope.$digest()
        http.flush()

        # Verify data
        errors = {"profile_first_name": "Missing value", "profile_last_name": "Missing value", "confirm": "Missing value", "password": "Enter a value 6 characters long or more"}
        expect(formMock.parseApiErrors).toHaveBeenCalledWith(errors)

    describe 'ForgotPasswordCtrl', ->
      it 'should be defined', inject ($rootScope, $controller) ->
        scope = $rootScope
        ctrl = $controller('ForgotPasswordCtrl', {$scope: scope})

        expect(ctrl).toBeDefined()

      it 'should submit forgot password', inject ($rootScope, $httpBackend, $controller, $location, _Flash_) ->
        scope = $rootScope
        http = $httpBackend
        ctrl = $controller('ForgotPasswordCtrl', {$scope: scope})
        flash = _Flash_

        # Verify/set data
        expect(flash.level).toEqual 'info'
        expect(flash.message).toEqual ''
        data = {email: 'test@example.com'}
        response = {"errors": {}, "data": {}}
        ctrl.email = data.email

        http.expectPOST('http://localhost:6543/api/users/forgot_password', data).respond(200, response)
        promise = ctrl.submit(formMock)
        data = promise.$object
        $rootScope.$digest()
        http.flush()

        # Verify data
        expect(flash.level).toEqual 'info'
        expect(flash.message).toEqual 'Password reset link has been emailed to you.'

      it 'should return errors on invalid submit', inject ($rootScope, $httpBackend, $controller) ->
        scope = $rootScope
        http = $httpBackend
        ctrl = $controller('ForgotPasswordCtrl', {$scope: scope})
        spyOn(formMock, 'parseApiErrors')

        data = {email: 'test@example'}
        response = {"errors": {"email": "The domain portion of the email address is invalid (the portion after the @: example)"}, "data": null}
        ctrl.email = data.email

        http.expectPOST('http://localhost:6543/api/users/forgot_password', data).respond(422, response)
        promise = ctrl.submit(formMock)
        data = promise.$object
        $rootScope.$digest()
        http.flush()

        # Verify data
        expect(formMock.parseApiErrors).toHaveBeenCalledWith(response.errors)

    describe 'ResetPasswordCtrl', ->
      it 'should be defined', inject ($rootScope, $controller) ->
        scope = $rootScope
        ctrl = $controller('ResetPasswordCtrl', {$scope: scope})

        expect(ctrl).toBeDefined()

      it 'should submit reset password', inject ($rootScope, $httpBackend, $controller, $location, _Flash_) ->
        scope = $rootScope
        http = $httpBackend
        ctrl = $controller('ResetPasswordCtrl', {$scope: scope})
        flash = _Flash_

        # Verify/set data
        expect($location.path()).toEqual ''
        expect(flash.level).toEqual 'info'
        expect(flash.message).toEqual ''
        data = {token: 'testing', email: 'test@example.com', password: 'testing', confirm: 'testing'}
        response = {"errors": {}, "data": {}}
        ctrl.email = data.email
        ctrl.password = data.password
        ctrl.confirm = data.confirm
        ctrl.token = data.token

        http.expectPOST('http://localhost:6543/api/users/reset_password', data).respond(200, response)
        promise = ctrl.submit(formMock)
        data = promise.$object
        $rootScope.$digest()
        http.flush()

        # Verify data
        expect($location.path()).toEqual '/users/login.html'
        expect(flash.level).toEqual 'info'
        expect(flash.message).toEqual 'Your password was successfully changed.'

      it 'should return errors on invalid submit', inject ($rootScope, $httpBackend, $controller) ->
        scope = $rootScope
        http = $httpBackend
        ctrl = $controller('ResetPasswordCtrl', {$scope: scope})
        spyOn(formMock, 'parseApiErrors')

        data = {email: 'test@example'}
        response = {"errors": {"email": "The domain portion of the email address is invalid (the portion after the @: example)"}, "data": null}
        ctrl.email = data.email

        http.expectPOST('http://localhost:6543/api/users/reset_password', data).respond(422, response)
        promise = ctrl.submit(formMock)
        data = promise.$object
        $rootScope.$digest()
        http.flush()

        # Verify data
        expect(formMock.parseApiErrors).toHaveBeenCalledWith(response.errors)

  describe 'Services', ->
    svc = {}
    http = undefined

    describe 'User Service', ->
      beforeEach ->
        angular.mock.module('starter')

        inject (_Auth_, _Flash_, _User_, $httpBackend) ->
          svc.Auth = _Auth_
          svc.Flash = _Flash_
          svc.User = _User_
          http = $httpBackend

      afterEach ->
        svc.Auth.clear()

      it 'Valid Login', inject ($rootScope) ->
        data = {email: 'test@example.com', password: 'testing'}
        response = {"errors": {}, "data": {"id": 1, "profile": {"first_name": "First", "last_name": "Last"}, "role": "user", "email": "test@example.com", "api_token": "arstneio", "last_login": "never"}}

        # Shouldn't have a current user
        expect(svc.Auth.currentUser()).toEqual {}

        http.expectPOST('http://localhost:6543/api/users/login', data).respond(200, response)
        svc.User.login(data)
        $rootScope.$digest()
        http.flush()

        # Check user
        user = svc.User.current()
        expect(user.id).toEqual 1
        expect(user.full_name).toEqual 'First Last'
        expect(user.email).toEqual 'test@example.com'
        expect(user.role).toEqual 'user'
        expect(user.api_token).toEqual 'arstneio'
        expect(user.last_login).toEqual 'never'
        expect(user.authorization_token).toEqual 'dGVzdEBleGFtcGxlLmNvbTphcnN0bmVpbw=='

      it 'Invalid Login', inject ($rootScope) ->
        data = {email: 'test@example.com', password: 'invalid'}
        response = {"errors": {"_global": "Invalid email or password."}, "data": null}

        # Shouldn't have a current user
        expect(svc.Auth.currentUser()).toEqual {}

        http.expectPOST('http://localhost:6543/api/users/login', data).respond(422, response)
        deferred = svc.User.login(data)
        $rootScope.$digest()
        http.flush()

        # Check user
        expect(svc.Auth.isAuthenticated()).toBe false
        # Check response
        expect(deferred.$$state.status).toEqual 2
        expect(deferred.$$state.value._global).toEqual 'Invalid email or password.'

      it 'Valid Register', inject ($rootScope) ->
        data =
          email: 'test@example.com'
          password: 'testing'
          confirm: 'testing'
          profile:
            first_name: 'First'
            last_name: 'Last'
        response = {"errors": {}, "data": {"id": 1, "profile": {"first_name": "First", "last_name": "Last"}, "role": "user", "email": "test@example.com", "api_token": "arstneio", "last_login": "never"}}

        # Shouldn't have a current user
        expect(svc.Auth.currentUser()).toEqual {}

        http.expectPOST('http://localhost:6543/api/users/register', data).respond(200, response)
        svc.User.register(data)
        $rootScope.$digest()
        http.flush()

        # Check user
        user = svc.Auth.currentUser()
        expect(user.id).toEqual 1
        expect(user.full_name).toEqual 'First Last'
        expect(user.email).toEqual 'test@example.com'
        expect(user.role).toEqual 'user'
        expect(user.api_token).toEqual 'arstneio'
        expect(user.last_login).toEqual 'never'
        expect(user.authorization_token).toEqual 'dGVzdEBleGFtcGxlLmNvbTphcnN0bmVpbw=='

      it 'Invalid Register', inject ($rootScope) ->
        data = {email: 'test@example.com', password: 'invalid'}
        response = {"errors": {"profile": "Missing value", "confirm": "Missing value", "password": "Enter a value 6 characters long or more"}, "data": null}

        # Shouldn't have a current user
        expect(svc.Auth.currentUser()).toEqual {}

        http.expectPOST('http://localhost:6543/api/users/register', data).respond(422, response)
        deferred = svc.User.register(data)
        $rootScope.$digest()
        http.flush()

        # Check user
        expect(svc.Auth.isAuthenticated()).toBe false
        # Check response
        expect(deferred.$$state.status).toEqual 2
        expect(deferred.$$state.value.profile).toEqual 'Missing value'

      it 'Valid Forgot Password', inject ($rootScope) ->
        data = {email: 'test@example.com'}
        response = {"errors": {}, "data": {}}

        # Shouldn't have a current user
        expect(svc.Auth.currentUser()).toEqual {}

        http.expectPOST('http://localhost:6543/api/users/forgot_password', data).respond(200, response)
        svc.User.forgotPassword(data)
        $rootScope.$digest()
        http.flush()

      it 'Invalid Forgot Password', inject ($rootScope) ->
        data = {email: 'test@example'}
        response = {"errors": {"email": "The domain portion of the email address is invalid (the portion after the @: example)"}, "data": null}

        # Shouldn't have a current user
        expect(svc.Auth.currentUser()).toEqual {}

        http.expectPOST('http://localhost:6543/api/users/forgot_password', data).respond(422, response)
        deferred = svc.User.forgotPassword(data)
        $rootScope.$digest()
        http.flush()

        # Check user
        expect(svc.Auth.isAuthenticated()).toBe false
        # Check response
        expect(deferred.$$state.status).toEqual 2
        expect(deferred.$$state.value.email).toEqual 'The domain portion of the email address is invalid (the portion after the @: example)'

      it 'Valid Reset Password', inject ($rootScope) ->
        data = {token: 'testing', email: 'test@example.com', password: 'testing', confirm: 'testing'}
        response = {"errors": {}, "data": {}}

        # Shouldn't have a current user
        expect(svc.Auth.currentUser()).toEqual {}

        http.expectPOST('http://localhost:6543/api/users/reset_password', data).respond(200, response)
        svc.User.resetPassword(data)
        $rootScope.$digest()
        http.flush()

      it 'Invalid Reset Password', inject ($rootScope) ->
        data = {email: 'test@example'}
        response = {"errors": {"email": "The domain portion of the email address is invalid (the portion after the @: example)"}, "data": null}

        # Shouldn't have a current user
        expect(svc.Auth.currentUser()).toEqual {}

        http.expectPOST('http://localhost:6543/api/users/reset_password', data).respond(422, response)
        deferred = svc.User.resetPassword(data)
        $rootScope.$digest()
        http.flush()

        # Check user
        expect(svc.Auth.isAuthenticated()).toBe false
        # Check response
        expect(deferred.$$state.status).toEqual 2
        expect(deferred.$$state.value.email).toEqual 'The domain portion of the email address is invalid (the portion after the @: example)'
