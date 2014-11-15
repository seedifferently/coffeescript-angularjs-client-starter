describe 'Admin E2E Tests', ->
  beforeEach ->
    # Log in admin
    browser.get '#/users/login.html'
    element(By.model('login.email')).sendKeys 'admin@example.com'
    element(By.model('login.password')).sendKeys 'admin'
    element(By.buttonText('Login')).click()

    # Verify redirect and flash
    expect(browser.getCurrentUrl()).toMatch '#/$'

  afterEach ->
    # Log out
    element(By.linkText('Logout')).click()

  it 'should show admin index', ->
    browser.get '#/admin/'
    expect(browser.getTitle()).toEqual 'Starter'
    expect(element(By.css('.page-header h1')).getText()).toEqual 'Angular App  ADMIN'
    expect(element.all(By.css('p')).first().getText()).toContain 'Lorem ipsum dolor sit amet'
