//
//  HomeDomain.swift
//
//
//  Created by Jeremy Greenwood on 05/10/2022.
//

import Common
import Foundation
import LocationService
import MapKit
import Mock
import PlaceList

/// The Home domain is responsible for home view state and business logic
public struct HomeDomain: Equatable {
    enum Route: Equatable, Identifiable {
        var id: String { "\(self)" }

        case placeDetail(Place)
    }

    /// Home  state
    public struct State: Equatable {
        @BindableState var isLoading = false
        @BindableState var route: Route?
        @BindableState var mapCooridinate: MKCoordinateRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 0.0,
                longitude: 0.0),
            span: MKCoordinateSpan(
                latitudeDelta: 0.012,
                longitudeDelta: 0.012))
        @BindableState var searchText: String = ""
        var alertState: AlertState<Action>?
        var locationServiceState = LocationServiceDomain.State()
        var placeListState = PlaceListDomain.State()
        var places: [Place] = [] {
            didSet {
                placeListState.places = places
            }
        }
        var showMap = false

        public init() {}
    }

    /// Home  actions
    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case clearSearch
        case error(AppError?)
        case fetchLocation
        case fetchNearbyRestaurants
        case locationService(LocationServiceDomain.Action)
        case placeList(PlaceListDomain.Action)
        case onAppear
        case setRestaurants([Place])
        case showDetail(Place)
        case submitSearch
        case toggleMap
    }

    /// Home  environment (dependencies)
    public struct Environment {
        var locationServiceEnvironment: LocationServiceDomain.Environment
        var placeListEnvironment: PlaceListDomain.Environment
        var nearbySearch: (PlacesAPI, QueryParameters) -> Effect<[Place], AppError>
        var textSearch: (PlacesAPI, String, QueryParameters) -> Effect<[Place], AppError>

        public static var live = Self(
            locationServiceEnvironment: .live,
            placeListEnvironment: .live,
            nearbySearch: { api, parameters in
                api.nearbySearch(parameters)
                    .load()
                    .eraseToEffect()
            },
            textSearch: { api, text, parameters in
                api.textSearch(text, parameters: parameters)
                    .load()
                    .eraseToEffect()
            }
        )

        public static var mock = Self(
            locationServiceEnvironment: .mock,
            placeListEnvironment: .mock,
            nearbySearch: { _, _ in
                Effect(value: Mock.places)
            },
            textSearch: { _, _, _ in
                Effect(value: Mock.places)
            }
        )
    }

    public static let reducer = Reducer<State, Action, SystemEnvironment<Environment>>.combine(
        LocationServiceDomain.reducer
            .pullback(
                state: \.locationServiceState,
                action: /Action.locationService,
                environment: { $0.locationServiceEnvironment }),
        PlaceListDomain.reducer
            .pullback(
                state: \.placeListState,
                action: /Action.placeList,
                environment: { $0.map(\.placeListEnvironment) }),
        Reducer { state, action, environment in
            switch action {
            case .binding(\.$searchText):
                guard state.searchText.isEmpty else {
                    return .none
                }

                return Effect(value: .fetchNearbyRestaurants)

            case .binding:
                return .none

            case .clearSearch:
                state.searchText = ""
                return Effect(value: .fetchNearbyRestaurants)

            case .error(let error):
                state.alertState = AlertState(error)
                return .none

            case .fetchLocation:
                state.isLoading = true

                return .concatenate(
                    Effect(value: .locationService(.authorize)),
                    Effect(value: .locationService(.getLocation))
                )

            case .fetchNearbyRestaurants:
                guard let location = state.locationServiceState.location else {
                    return .none
                }

                state.isLoading = true

                return environment.nearbySearch(
                    environment.placesAPI,
                    QueryParameters(
                        location: (location.coordinate.latitude, location.coordinate.longitude))
                ).map(
                    scheduler: environment.mainQueue,
                    success: Action.setRestaurants,
                    failure: Action.error)

            case .locationService(.setLocation(let location)):
                state.mapCooridinate.center = CLLocationCoordinate2D(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude)
                return Effect(value: .fetchNearbyRestaurants)

            case .locationService:
                return .none

            case .placeList(.placeRow(let id, .rowWasSelected)):
                guard let place = state.places.first(where: { $0.id == id }) else {
                    return Effect(value: .error(AppError(reason: "Place cannot be found")))
                }

                return Effect(value: .showDetail(place))

            case .placeList:
                return .none

            case .onAppear:
                return Effect(value: .locationService(.configure))

            case .setRestaurants(let places):
                state.isLoading = false
                state.places = places
                return .none

            case .showDetail(let place):
                state.route = .placeDetail(place)
                return .none

            case .submitSearch:
                guard let location = state.locationServiceState.location else {
                    return .none
                }

                // if search term is empty, fall back to location search
                guard !state.searchText.isEmpty else {
                    return Effect(value: .fetchNearbyRestaurants)
                }

                state.isLoading = true

                return environment.textSearch(
                    environment.placesAPI,
                    state.searchText,
                    QueryParameters(
                        location: (
                            location.coordinate.latitude,
                            location.coordinate.longitude))
                ).map(
                    scheduler: environment.mainQueue,
                    success: Action.setRestaurants,
                    failure: Action.error)

            case .toggleMap:
                state.showMap.toggle()
                return .none
            }
        }.binding()
    )
}

/// Conform MKCoordinateRegion to Equatable
extension MKCoordinateRegion: Equatable {
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        lhs.center.latitude == rhs.center.latitude &&
        lhs.center.longitude == rhs.center.longitude
    }
}
