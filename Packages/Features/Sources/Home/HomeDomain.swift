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
import Model

public struct HomeDomain: Equatable {
    enum Route: Equatable {
        case placeDetail(Place)
    }

    public struct State: Equatable {
        @BindableState var route: Route?
        var locationServiceState = LocationServiceDomain.State()
        var places: [Place] = []
        var showMap = false

        public var name: String

        public init(name: String = "") {
            self.name = name
        }
    }

    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case fetchLocation
        case fetchRestaurants
        case locationService(LocationServiceDomain.Action)
        case onAppear
        case setRestaurants([Place])
        case toggleMap
    }

    public struct Environment {
        var locationServiceEnvironment: LocationServiceDomain.Environment

        public static var live = Self(
            locationServiceEnvironment: .live
        )

        public static var mock = Self(
            locationServiceEnvironment: .mock
        )
    }

    public static let reducer = Reducer<State, Action, SystemEnvironment<Environment>>.combine(
        LocationServiceDomain.reducer
            .pullback(
                state: \.locationServiceState,
                action: /Action.locationService,
                environment: { $0.locationServiceEnvironment }),
        Reducer { state, action, _ in
            switch action {
            case .binding:
                return .none

            case .fetchLocation:
                return .none

            case .fetchRestaurants:
                return .none

            case .locationService:
                return .none

            case .onAppear:
                state.name = "Home"
                return .none

            case .setRestaurants(let places):
                state.places = places
                return .none

            case .toggleMap:
                state.showMap.toggle()
                return .none
            }
        }.binding()
    )
}
