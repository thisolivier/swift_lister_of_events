# Lister of Events
_API's, Caching and Persistence oh my!_

An app that lists some events, with a lovely set of features, including:

* Image caching
* Paginated loading with memory control
* Connectivity feedback to user
* Ability to set events as favourites
* Persistent storage of favourites
* Offline mode where favourites are still visible

## Requirements

* Xcode 11 (with support for iOS13.2)

## Running

* Open Xcode
* Build project
* Relax

## Limitations

Since this is a demonstation, there's always a limit to what I can show. In this case the following items would be the next features I'd look to add.

* Tests - Testing the Stores, Services and Interactor in XCTests - their dependecies are easy to subclass into mocks or implement procol wrappers around. Using a mock Interactor one could test the ViewController using XCUITests. 
* Better connectivity feedback - At the moment the information a user is given is limited and the view used could be better designed.
* Option to reset favourites - Easy to add, but not part of the spec.
