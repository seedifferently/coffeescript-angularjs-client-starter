describe 'Admin Unit Tests', ->
  beforeEach angular.mock.module('starter')

  describe 'Routes', ->
    it 'should map Root routes to AdminCtrl', inject ($route) ->
      expect($route.routes['/admin/'].controller).toBe('AdminCtrl')
      expect($route.routes['/admin/'].templateUrl).toEqual('tmpl/admin/index.html')

    it 'should resolve ACL for /admin/', inject ($route, _Auth_) ->
      auth = _Auth_
      testUserData =
        id: 1
        email: 'test@example.com'
        role: 'user'
        api_token: 'arstneio'
        last_login: 'never'
        profile:
          first_name: 'First'
          last_name: 'Last'

      # Unauthenticated
      expect($route.routes['/admin/'].resolve.acl(auth).$$state.status).toEqual 2
      expect($route.routes['/admin/'].resolve.acl(auth).$$state.value).toEqual 'auth-not-authenticated'

      # Unauthorized
      auth.setUser(testUserData)
      expect(auth.isAuthenticated()).toBe true
      expect($route.routes['/admin/'].resolve.acl(auth).$$state.status).toEqual 2
      expect($route.routes['/admin/'].resolve.acl(auth).$$state.value).toEqual 'auth-not-authorized'

      # Authorized
      testUserData.role = 'admin'
      auth.setUser(testUserData)
      expect(auth.isAuthenticated()).toBe true
      expect($route.routes['/admin/'].resolve.acl(auth).$$state.status).toEqual 1
      expect($route.routes['/admin/'].resolve.acl(auth).$$state.value).toEqual 'auth-authorized'
      auth.clear()

  describe 'AdminCtrl', ->
    it 'should be defined', inject ($rootScope, $controller) ->
      scope = $rootScope
      ctrl = $controller('AdminCtrl', {$scope: scope})

      expect(ctrl).toBeDefined()
