# Lister of Events

An app that lists some events, with a lovely set of features, including:

* Image caching
* Paginated loading with memory control
* Connectivity feedback to user
* Ability to set events as favourites
* Persistent storage of favourites
* Offline mode where favourites are still visible

The app keeps data flowing unidirectionally, as opposed to two way binding on data. Actions from Views drive changes in data stores via services (helper classes), the Views then get the new data when they query the stores.

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
* Better use iOS's Combine framework to expose DataPublishers at the service and interactor level, reducing the number of completion handlers passed around.
* Introduce a Presenter layer to reduce interactor's responsabilities (such as formatting the date and making configuration structs)
