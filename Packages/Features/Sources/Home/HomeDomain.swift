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

public struct HomeDomain: Equatable {
    public struct State: Equatable {
        var locationServiceState = LocationServiceDomain.State()

        public var name: String

        public init(name: String = "") {
            self.name = name
        }
    }

    public enum Action: Equatable {
        case locationService(LocationServiceDomain.Action)
        case onAppear
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
            case .locationService:
                return .none

            case .onAppear:
                state.name = "Home"
                return .none
            }
        }
    )
}
