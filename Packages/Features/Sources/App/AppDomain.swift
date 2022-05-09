//
//  AppDomain.swift
//
//
//  Created by Jeremy Greenwood on 05/07/2022.
//

import Common
import ComposableArchitecture
import Foundation
import LocationAccess

public struct AppDomain: Equatable {
    public struct State: Equatable {
        var locationAccessState: LocationAccessDomain.State?
        var locationServiceState = LocationServiceDomain.State()
        public var name: String

        public init(name: String = "") {
            self.name = name
        }
    }

    public enum Action: Equatable {
        case onAppear
        case locationAccess(LocationAccessDomain.Action)
        case locationService(LocationServiceDomain.Action)
    }

    public struct Environment {
        var locationAccessEnvironment: LocationAccessDomain.Environment
        var locationServiceEnvironment: LocationServiceDomain.Environment

        public static var live = Self(
            locationAccessEnvironment: .live,
            locationServiceEnvironment: .live)

        public static var mock = Self(
            locationAccessEnvironment: .mock,
            locationServiceEnvironment: .mock)
    }

    public static let reducer = Reducer<State, Action, SystemEnvironment<Environment>>.combine(
        LocationAccessDomain.reducer
            .optional()
            .pullback(
                state: \.locationAccessState,
                action: /Action.locationAccess,
                environment: { $0.map(\.locationAccessEnvironment) }),
        LocationServiceDomain.reducer
            .pullback(
                state: \.locationServiceState,
                action: /Action.locationService,
                environment: { $0.locationServiceEnvironment }),
        Reducer { state, action, _ in
            switch action {
            case .onAppear:
                state.name = "App"
                return Effect(value: .locationService(.getServiceStatus))

            case .locationAccess:
                return .none

            case .locationService(.setServiceStatus):
                if state.locationServiceState.authorizationStatus == .authorized {

                } else {
                    state.locationAccessState = LocationAccessDomain.State(locationServiceState: state.locationServiceState)
                }

                return .none

            case .locationService:
                return .none
            }
        }
    )
}
