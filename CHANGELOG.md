# Changelog

## v0.7.5 - 17.03.2016

* Use `request.xhr?` instead of `request.content_type` in failure app

## v0.7.3 - 09.12.2015

* Fix user_signed_in? on not restricted actions

## v0.7.2 - 08.12.2015

* Fix fetching user data on not restricted actions

## v0.7.1 - 11.09.2015

* Wrap configuration logic into Configuration class
* Raise error when provider_url is missing
* Fix mocking token

## v0.7.0 - 19.08.2015

* Remember user's current path
* Allow to mock signed out state

**Backward incomatible changes**

* Select profile mock based on access token mock
* Require explicite include of helpers

## v0.6.0 - 29.06.2015

* Mock profile request, not OmniAuth
* Custom FailureApp
* Handle JSON in default FailureApp

## v0.5.0 - 29.04.2015

* Mocking feature

## v0.4.0 - 09.04.2015

* Use warden under the hood
* Inject into initialization process so calling for OmniAuth client could take Rack env

## v0.3.5 - 01.04.2015

* Use Rails rack app when initializing omniauth strategy object

## v0.3.4 - 01.04.2015

* Support OmniAuth camelization strategy
