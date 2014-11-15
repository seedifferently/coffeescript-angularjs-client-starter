================================================================================
Welcome to Starter
================================================================================

**Note: This code is part of a collection of various starter examples. See more
at: https://github.com/seedifferently/starters**

This is an opinionated CoffeeScript AngualrJS web client application.


--------------------------------------------------------------------------------
Getting Started
--------------------------------------------------------------------------------

Environment Setup
^^^^^^^^^^^^^^^^^

In order to set up the app, you'll need to have Node.js_ installed. If you don't
already, then I'd recommend using `Node Version Manager`_.


.. _Node.js: http://www.nodejs.org/
.. _Node Version Manager: https://github.com/creationix/nvm


Project Setup
^^^^^^^^^^^^^

1. (*Only if using NVM*) Install/initialize a recent version of Node.js/NPM by
   running these two commands in the project's root directory::

    nvm install
    nvm alias default

2. Install the app's dependencies by running ``npm install`` in the project's
   root directory.

3. Configure, and run the `Pyramid Starter app`_, which is the backend service
   for this app.


.. _Pyramid Starter app: https://github.com/seedifferently/pyramid-starter


--------------------------------------------------------------------------------
Running the App
--------------------------------------------------------------------------------

Once all dependencies have been installed, you can start the app by running::

    npm start

Your application should then be available at: http://localhost:8080/


--------------------------------------------------------------------------------
Testing
--------------------------------------------------------------------------------

The application's test suite can be found in the ``src/tests`` directory. It is
utilizes `Karma`_ for unit tests and `Protractor`_ for E2E tests.


.. _Karma: https://github.com/angular/protractor
.. _Protractor: http://karma-runner.github.io/


Running the Tests
^^^^^^^^^^^^^^^^^

You can run the tests by typing::

    npm test

This will run the full test suite including all ``unit`` and ``E2E`` tests. Type
``npm run`` to see other testing options.


.. caution:: The E2E tests expect the Pyramid Starter app to be running on port
             ``6543`` with a pristine database.
