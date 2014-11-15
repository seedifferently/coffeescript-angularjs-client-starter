describe 'Root Unit Tests', ->
  beforeEach angular.mock.module('starter')

  describe 'Routes', ->
    it 'should map Root routes to RootCtrl', inject ($route) ->
      expect($route.routes['/'].controller).toBe('RootCtrl')
      expect($route.routes['/'].templateUrl).toEqual('tmpl/root/index.html')

      expect($route.routes['/about.html'].controller).toBe('RootCtrl')
      expect($route.routes['/about.html'].templateUrl).toEqual('tmpl/root/about.html')

  describe 'RootCtrl', ->
    it 'should be defined', inject ($rootScope, $controller) ->
      scope = $rootScope
      ctrl = $controller('RootCtrl', {$scope: scope})

      expect(ctrl).toBeDefined()
