//
//  LocationAccessDomain.swift
//
//
//  Created by Jeremy Greenwood on 05/08/2022.
//

import Common
import ComposableArchitecture
import Foundation
import LocationService
import CoreLocation

public struct LocationAccessDomain: Equatable {
    public struct State: Equatable {
        var locationServiceState = LocationServiceDomain.State()

        var locationEnabled: Bool {
            locationServiceState.locationServiceEnabled
        }

        var authorizationStatus: LocationServiceDomain.AuthorizationStatus {
            locationServiceState.authorizationStatus
        }

        var showConfirmButton: Bool {
            locationEnabled && authorizationStatus == .notDetermined
        }

        public init() {}
    }

    public enum Action: Equatable {
        case didCompleteAuthorization
        case didSelectConfirm
        case locationService(LocationServiceDomain.Action)
        case onAppear
    }

    public struct Environment {
        var locationServiceEnvironment: LocationServiceDomain.Environment

        public static var live = Self(
            locationServiceEnvironment: .live)

        public static var mock = Self(
            locationServiceEnvironment: .mock)
    }

    public static let reducer = Reducer<State, Action, SystemEnvironment<Environment>>.combine(
        Reducer { state, action, _ in
            switch action {
            case .didCompleteAuthorization:
                return .none

            case .didSelectConfirm:
                return Effect(value: .locationService(.authorize))

            case .onAppear:
                return Effect(value: .locationService(.getServiceStatus))

            case .locationService(.locationManager(.didChangeAuthorization)):
                if state.authorizationStatus == .authorized {
                    return Effect(value: .didCompleteAuthorization)
                }

                return .none

            case .locationService:
                return .none
            }
        },
        LocationServiceDomain.reducer
            .pullback(
                state: \.locationServiceState,
                action: /Action.locationService,
                environment: { $0.locationServiceEnvironment })
    )
}
