# LunchPlaces Sample Project
 
## Summary
This is a sample project illustrating how to use [The Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture) (TCA) and [SwiftUI](https://developer.apple.com/xcode/swiftui/) to build a location aware RESTful API client.
 
I focused the majority of my time on 3 aspects of the project, together they make up the app Architecture: Data Flow, Modularity, and Testability.
 
*Data Flow*: TCA implements a classic unidirectional data flow design. I use the metaphor "Domain" to represent a feature's business logic. Domain defines a state which represents the state of the UI. The UI is bound to state via SwiftUI. Actions within the UI are sent to a domain to be handled by the reducer, which then updates state as needed. Which of course, updates the UI and the State->UI->Action cycle continues.
 
*Modularity*: I utilized Swift Package Manager to help facilitate separation of concerns by splitting model, network, and business logic into discrete modules. The value of this particular aspect is often overlooked, however doing so allows increased shareability, clear API boundaries, and better access control.
 
*Testability*: I've implemented the type `SystemEnvironment`. This type is used to control any aspect of the "World" that we otherwise don't have control over, and control is key for testability. A domain, by way of Dependency Injection, is initialized with an instance of `Environment` with 1 of 3 primary instance names: `live`, `mock`, and `failing`. Live is used for production apps, mock for SwiftUI previews and offline development, and failing for unit testing.
 
## Packages
 
### Cache
Defines the generic `Caching` protocol. Also adds a convenience conformance to `UserDefaults`
 
### Core
Defines base model types like `AppError` and extensions on `Foundation`. Does not have any dependencies
 
### Features
Contains the bulk of the app's logic and views in the form of separate feature targets. For the most part, each major view is represented as a feature target. 2 additional targets which don't have a view are `Common` (holds shared code needed by other feature targets) and `LocationService` (simplifies CoreLocation interaction).
 
### Localization
Contains the localized strings definition and a strongly typed help struct for ease of use. 
 
### Mock
Defines an API payload which can be used for stubbing data and unit testing.
 
### Model
Defines the Google Places API response.
 
### PlaceAPI
Models the API endpoints and adds a convenience `load()` method which performs the API transaction. Depends on [TinyNetworking](https://github.com/objcio/tiny-networking)
 
### UIComponents
Holds common UI components and style definitions to be shared throughout the app.
 
## Trade-Offs
This implementation uses `SwiftUI`'s `Map` view, which is fairly limited at the moment. This impacted annotations and map callouts. A proper way to do this would be to wrap `UIMapView` by conforming it to `UIViewRepresentable`. This would expose it to `SwiftUI` and allow for greater customization.
 
A TCA project requires a bit of a learning curve to implement and read, which can be somewhat time consuming. The payoff is an incredibly scalable codebase who's features are highly testable and composable.
 
## Misc
 
### Requirements
- Xcode 13.3
- Swift 5.6
 
### Google Places API
I obfuscated the API Key so as not to expose it publicly. Add your key to `Config.xcconfig` or the app will `fatalError`.
