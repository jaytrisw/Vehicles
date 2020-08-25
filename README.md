# Vehicles

By [Joshua Wood](mailto:joshuatw@gmail.com)

## Installation Instructions

```
git clone https://github.com/jaytrisw/Vehicles.git
cd Vehicles
pod install
open Vehicles.xcworkspace
```

## Description

A simple iOS application that downloads a JSON feed and displays the decoded elements in a UITableView and MKMapView and uses a UITabBarController to handle application navigation.

Decoded elements are persistently stored in the devices' documents directory as Data.

### Third Party Libraries Used
- RxSwift
- RxCocoa
- RxRelay

#### Screen 1
- A UITableView that holds the downloaded list of vehicles, and a UISearchController to help filter the vehicles.  Selecting a vehicle in the UITableView will select the map controller and select the annotation for the selected item.

#### Screen 2
- A MKMapView that displays the vehicles at their last known coordinate.

## Technical Considerations
#### Architecture
I have used the MVVM pattern with a coordinator to handle navigation.

Although with this simple application, a coordinator might not be warranted, I built it assuming we would be adding features that would necessitate such an inclusion.

#### Testability

I have written tests for two components.  The first being tests on the persistence service to insure that files could successfully be saved, fetched, and deleted from the documents directory.

I also performed tests on my list view model, this involved mocking a network service to return some Vehicle objects.

#### Extensibility
Objects use protocols where appropriate.  This allows us to create new concrete implementations should the need arise.  We could, for example, change our persistence service to implement Realm or CoreData without needing to change any other code.
