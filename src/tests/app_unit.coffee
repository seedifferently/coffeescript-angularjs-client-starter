describe 'App Unit Tests', ->
  beforeEach angular.mock.module('starter')

  describe 'Controllers', ->
    describe 'AppCtrl', ->
      it 'should be defined', inject ($rootScope, $controller) ->
        scope = $rootScope
        ctrl = $controller('AppCtrl', {$scope: scope})

        expect(ctrl).toBeDefined()

      it 'should return current path', inject ($rootScope, $controller) ->
        scope = $rootScope
        ctrl = $controller('AppCtrl', {$scope: scope})

        expect(ctrl.currentPath()).toEqual ''

      it 'should handle flash events', inject ($rootScope, $controller, _Flash_) ->
        scope = $rootScope
        ctrl = $controller('AppCtrl', {$scope: scope})
        flash = _Flash_

        # Check values
        expect(scope.flashClass).toEqual 'alert-info'
        expect(scope.flashMessage).toEqual ''

        # Broadcast flash message
        flash.flash('testing 1 2 3', 'success')

        # Check values
        expect(scope.flashClass).toEqual 'alert-success'
        expect(scope.flashMessage).toEqual 'testing 1 2 3'

        # Broadcast flash clear
        flash.clear()

        # Check values
        expect(scope.flashClass).toEqual 'alert-success'
        expect(scope.flashMessage).toEqual ''

    describe 'HeaderCtrl', ->
      it 'should be defined', inject ($rootScope, $controller) ->
        scope = $rootScope
        ctrl = $controller('HeaderCtrl', {$scope: scope})

        expect(ctrl).toBeDefined()

      it 'should successfully logout', inject ($rootScope, $controller, _Auth_, _Flash_) ->
        scope = $rootScope
        ctrl = $controller('HeaderCtrl', {$scope: scope})
        auth = _Auth_
        flash = _Flash_
        testUserData =
          id: 1
          email: 'test@example.com'
          role: 'user'
          api_token: 'arstneio'
          last_login: 'never'
          profile:
            first_name: 'First'
            last_name: 'Last'

        # Log in and verify
        auth.setUser(testUserData)
        expect(auth.isAuthenticated()).toBe true
        expect(flash.level).toEqual 'info'
        expect(flash.message).toEqual ''

        # Log out and verify
        logout = ctrl.logout()
        expect(auth.isAuthenticated()).toBe false
        expect(auth.currentUser()).toEqual {}
        expect(flash.level).toEqual 'success'
        expect(flash.message).toEqual 'You have successfully logged out.'
        expect(logout.$$path).toEqual '/'

    describe 'FooterCtrl', ->
      it 'should be defined', inject ($rootScope, $controller) ->
        scope = $rootScope
        ctrl = $controller('FooterCtrl', {$scope: scope})

        expect(ctrl).toBeDefined()

  describe 'Services', ->
    svc = undefined
    http = undefined

    describe 'Auth Service', ->
      testUserData =
        id: 1
        email: 'test@example.com'
        role: 'user'
        api_token: 'arstneio'
        last_login: 'never'
        profile:
          first_name: 'First'
          last_name: 'Last'

      beforeEach ->
        angular.mock.module('starter')

        inject (_Auth_, $httpBackend) ->
          svc = _Auth_
          http = $httpBackend

      afterEach ->
        svc.clear()

      it 'Check defaults', ->
        expect(svc.next).toEqual '/'

      it 'Should be able to set/get user info', ->
        svc.setUser(testUserData)
        user = svc.currentUser()

        expect(user.id).toEqual 1
        expect(user.full_name).toEqual 'First Last'
        expect(user.email).toEqual 'test@example.com'
        expect(user.role).toEqual 'user'
        expect(user.api_token).toEqual 'arstneio'
        expect(user.last_login).toEqual 'never'
        expect(user.authorization_token).toEqual 'dGVzdEBleGFtcGxlLmNvbTphcnN0bmVpbw=='

      it 'Should be able to check authentication', ->
        svc.setUser(testUserData)
        expect(svc.isAuthenticated()).toBe true
        svc.clear()
        expect(svc.isAuthenticated()).toBe false

      it 'Should be able to check authorization', ->
        svc.setUser(testUserData)
        expect(svc.isAuthorized(svc.ACL.user)).toBe true
        expect(svc.isAuthorized(svc.ACL.admin)).toBe false
        expect(svc.isAuthorized('user')).toBe true
        expect(svc.isAuthorized('admin')).toBe false
        svc.clear()
        expect(svc.isAuthorized(svc.ACL.user)).toBe false
        expect(svc.isAuthorized('user')).toBe false
        expect(svc.isAuthorized('')).toBe false
        expect(svc.isAuthorized()).toBe false

      it 'Should be able to resolve ACLs', inject ($rootScope) ->
        resolved = undefined
        svc.setUser(testUserData)

        svc.resolveAcl(svc.ACL.user).then (result) ->
          resolved = result
        , (result) ->
          resolved = result
        $rootScope.$digest()

        expect(svc.next).toEqual '/'
        expect(resolved).toEqual svc.EVENTS.authorized

        svc.resolveAcl(svc.ACL.admin).then (result) ->
          resolved = result
        , (result) ->
          resolved = result
        $rootScope.$digest()

        expect(svc.next).toEqual '/'
        expect(resolved).toEqual svc.EVENTS.notAuthorized

        # Logout
        svc.clear()

        svc.resolveAcl(svc.ACL.user).then (result) ->
          resolved = result
        , (result) ->
          resolved = result
        $rootScope.$digest()

        expect(svc.next).toEqual '/users/me.html'
        expect(resolved).toEqual svc.EVENTS.notAuthenticated

    describe 'Flash Service', ->
      beforeEach ->
        angular.mock.module('starter')

        inject (_Flash_, $httpBackend) ->
          svc = _Flash_
          http = $httpBackend

      it 'Check defaults', ->
        expect(svc.level).toEqual 'info'
        expect(svc.message).toEqual ''
        expect(svc.reset).toEqual undefined

      it 'Should flash to the "info" level if no level is specified', ->
        svc.flash('Test')

        expect(svc.level).toEqual 'info'
        expect(svc.message).toEqual 'Test'
        expect(svc.reset).toBeUndefined()

      it 'Should be able to clear flash', ->
        svc.flash('Test')
        expect(svc.message).toEqual 'Test'

        # Shouldn't clear if wrong level is specified
        svc.clear('danger')
        expect(svc.level).toEqual 'info'
        expect(svc.message).toEqual 'Test'

        # Should clear if right level is specified
        svc.clear('info')
        expect(svc.level).toEqual 'info'
        expect(svc.message).toEqual ''

        # Should clear if no level is specified
        svc.flash('Test')
        expect(svc.message).toEqual 'Test'
        svc.clear()
        expect(svc.level).toEqual 'info'
        expect(svc.message).toEqual ''

      it 'Should empty flash on cleanup', inject ($timeout) ->
        svc.flash('Test')
        svc.cleanup()
        $timeout.flush()

        expect(svc.level).toEqual 'info'
        expect(svc.message).toEqual ''
        expect(svc.reset).toBeDefined()
