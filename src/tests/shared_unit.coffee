describe 'Shared Unit Tests', ->
  describe 'Directives', ->
    scope = undefined
    compile = undefined
    svc = {}

    beforeEach ->
      angular.mock.module('starter')
      inject ($compile, $rootScope, _Flash_) ->
        compile = $compile
        scope = $rootScope.$new()
        svc.Flash = _Flash_

    describe 'apiValidate Directive', ->
      it 'Should process API validation errors', ->
        tmpl = angular.element [
          '<form method="post" name="form" api-validate>'
            '<input name="test" ng-model="test" />'
            '<span ng-show="form.hasErrorMessage(\'test\')" ng-bind="form.test.$error.message" />'
            '<input name="test_nested" ng-model="test.nested" />'
            '<span ng-show="form.hasErrorMessage(\'test_nested\')" ng-bind="form.test_nested.$error.message" />'
            '<input type="submit" value="Submit" />'
          '</form>'
        ].join('')
        compile(tmpl)(scope)
        scope.$digest()
        form = scope.form

        # No errors on init
        expect(form.hasError('test')).toBe false
        expect(form.hasErrorMessage('test')).toBe false
        expect(form.hasError('test_nested')).toBe false
        expect(form.hasErrorMessage('test_nested')).toBe false
        expect(form.parseApiErrors).toBeDefined()

        # Set/check errors
        form.parseApiErrors({'_global': 'Test invalid global.', 'test': 'Test invalid field.', 'test.nested': 'Test invalid nested field.'})
        scope.$digest()
        expect(form.hasError('test')).toBe true
        expect(form.hasError('test_nested')).toBe true
        expect(form.hasErrorMessage('test')).toBe true
        expect(form.hasErrorMessage('test_nested')).toBe true
        expect(form.test.$error.message).toEqual 'Test invalid field.'
        expect(form.test_nested.$error.message).toEqual 'Test invalid nested field.'
        # Global error should be flashed
        expect(svc.Flash.message).toEqual 'Test invalid global.'
        # Template should show errors
        expect(tmpl.find('span').text()).toEqual 'Test invalid field.Test invalid nested field.'

        # Should reset on submit
        tmpl.find('input')[2].click()
        scope.$digest()
        expect(form.hasError('test')).toBe false
        expect(form.hasErrorMessage('test')).toBe false
        # Template shouldn't show errors
        expect(tmpl.find('span').text()).toEqual ''
        # Global error should be cleared
        expect(svc.Flash.message).toEqual ''

        # Should ignore errors for invalid/missing fields
        form.parseApiErrors({'invalid': 'Test invalid field.'})
        expect(form.hasError('invalid')).toBe false
        expect(form.hasErrorMessage('invalid')).toBe false
