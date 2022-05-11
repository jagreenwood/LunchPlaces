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
import Home

public struct AppDomain: Equatable {
    public struct State: Equatable {
        var homeState = HomeDomain.State()
        var locationAccessState: LocationAccessDomain.State?
        var locationServiceState = LocationServiceDomain.State()

        public init() {}
    }

    public enum Action: Equatable {
        case home(HomeDomain.Action)
        case onAppear
        case locationAccess(LocationAccessDomain.Action)
        case locationService(LocationServiceDomain.Action)
    }

    public struct Environment {
        var homeEnvironment: HomeDomain.Environment
        var locationAccessEnvironment: LocationAccessDomain.Environment
        var locationServiceEnvironment: LocationServiceDomain.Environment

        public static var live = Self(
            homeEnvironment: .live,
            locationAccessEnvironment: .live,
            locationServiceEnvironment: .live)

        public static var mock = Self(
            homeEnvironment: .mock,
            locationAccessEnvironment: .mock,
            locationServiceEnvironment: .mock)
    }

    public static let reducer = Reducer<State, Action, SystemEnvironment<Environment>>.combine(
        HomeDomain.reducer
            .pullback(
                state: \.homeState,
                action: /Action.home,
                environment: { $0.map(\.homeEnvironment) }),
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
            case .home:
                return .none

            case .onAppear:
                return Effect(value: .locationService(.getServiceStatus))

            case .locationAccess(.didCompleteAuthorization):
                state.locationAccessState = nil
                return .merge(
                    Effect(value: .locationService(.authorize)),
                    Effect(value: .home(.fetchLocation))
                )

            case .locationAccess:
                return .none

            case .locationService(.setServiceStatus):
                if state.locationServiceState.authorizationStatus == .authorized &&
                    state.locationServiceState.locationServiceEnabled == true {
                    state.locationAccessState = nil // dismiss location access view

                    return .merge(
                        Effect(value: .locationService(.authorize)),
                        Effect(value: .home(.fetchLocation))
                    )
                } else {
                    state.locationAccessState = LocationAccessDomain.State(locationServiceState: state.locationServiceState)

                    return .none
                }

            case .locationService:
                return .none
            }
        }
    )
}
