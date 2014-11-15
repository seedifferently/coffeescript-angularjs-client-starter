describe 'Root E2E Tests', ->
  it 'should show root index', ->
    browser.get '/'
    expect(browser.getTitle()).toEqual('Starter')
    expect(element(By.css('.jumbotron h1')).getText()).toEqual('Starter');
    expect(element.all(By.css('.jumbotron p')).first().getText()).toContain('Lorem ipsum dolor sit amet');

  it 'should show root about', ->
    browser.get '#/about.html'
    expect(browser.getTitle()).toEqual('Starter')
    expect(element(By.css('.jumbotron h1')).getText()).toEqual('About');
    expect(element.all(By.css('.jumbotron p')).first().getText()).toContain('Lorem ipsum dolor sit amet');
