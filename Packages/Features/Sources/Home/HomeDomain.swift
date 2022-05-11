//
//  HomeDomain.swift
//
//
//  Created by Jeremy Greenwood on 05/10/2022.
//

import Common
import ComposableArchitecture
import Foundation
import LocationService
import Mock
import PlaceList
import PlacesAPI

public struct HomeDomain: Equatable {
    enum Route: Equatable {
        case placeDetail(Place)
    }

    public struct State: Equatable {
        @BindableState var route: Route?
        var alertState: AlertState<Action>?
        var locationServiceState = LocationServiceDomain.State()
        var placeListState = PlaceListDomain.State()
        var places: [Place] = []
        var showMap = false

        public var name: String

        public init(name: String = "") {
            self.name = name
        }
    }

    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case error(AppError?)
        case fetchLocation
        case fetchNearbyRestaurants
        case locationService(LocationServiceDomain.Action)
        case placeList(PlaceListDomain.Action)
        case onAppear
        case setRestaurants([Place])
        case toggleMap
    }

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
            case .binding:
                return .none

            case .error(let error):
                state.alertState = AlertState(error)
                return .none

            case .fetchLocation:
                return Effect(value: .locationService(.getLocation))

            case .fetchNearbyRestaurants:
                guard let location = state.locationServiceState.location else {
                    return .none
                }

                return environment.nearbySearch(
                    environment.placesAPI,
                    QueryParameters(
                        location: (location.coordinate.latitude, location.coordinate.longitude))
                ).map(
                    scheduler: environment.mainQueue,
                    success: Action.setRestaurants,
                    failure: Action.error)

            case .locationService(.setLocation(let location)):
                return Effect(value: .fetchNearbyRestaurants)

            case .locationService:
                return .none

            case .placeList:
                return .none

            case .onAppear:
                state.name = "Home"
                return Effect(value: .locationService(.configure))

            case .setRestaurants(let places):
                state.places = places
                return .none

            case .toggleMap:
                state.showMap.toggle()
                return .none
            }
        }.binding().debug()
    )
}
