//
//  LocationServiceDomain.swift
//
//
//  Created by Jeremy Greenwood on 05/08/2022.
//

import Core
import Combine
import ComposableCoreLocation
import Foundation

public struct LocationServiceDomain: Equatable {
    public enum AuthorizationStatus {
        case authorized
        case denied
        case notDetermined
    }

    public struct State: Equatable {
        public var error: AppError?
        public var location: Location?
        public var locationServiceEnabled: Bool
        var clAuthorizationStatus: CLAuthorizationStatus

        public var authorizationStatus: AuthorizationStatus {
            switch clAuthorizationStatus {
            case .notDetermined:
                return .notDetermined
            case .restricted, .denied:
                return .denied
            case .authorizedAlways, .authorizedWhenInUse, .authorized:
                return .authorized
            @unknown default:
                fatalError("Unknown auth status")
            }
        }

        public init(
            authorizationStatus: CLAuthorizationStatus = .notDetermined,
            error: AppError? = nil,
            location: Location? = nil,
            locationServiceEnabled: Bool = true) {
                self.clAuthorizationStatus = authorizationStatus
                self.error = error
                self.location = location
                self.locationServiceEnabled = locationServiceEnabled
            }
    }

    public enum Action: Equatable {
        case authorize
        case error(_ error: AppError?)
        case getLocation
        case getServiceStatus
        case locationManager(LocationManager.Action)
        case setLocation(Location)
        case setServiceStatus(CLAuthorizationStatus, Bool)
    }

    public struct Environment {
        var locationManager: LocationManager

        public static let live = Self(
            locationManager: .live)

        public static let mock = Self(
            locationManager: .mock)
    }

    public static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .authorize:
            return .merge(
                environment.locationManager
                    .delegate()
                    .map(Action.locationManager),
                environment.locationManager
                    .requestWhenInUseAuthorization()
                    .fireAndForget()
            )

        case .error(let error):
            state.error = error
            return .none

        case .getLocation:
            return environment.locationManager
                .requestLocation()
                .fireAndForget()

        case .getServiceStatus:
            return Effect(value: .setServiceStatus(
                environment.locationManager.authorizationStatus(),
                environment.locationManager.locationServicesEnabled()))

        case .locationManager(let action):
            switch action {
            case .didChangeAuthorization:
                return Effect(value: .getServiceStatus)

            case .didUpdateLocations(let locations):
                guard let location = locations.first else {
                    return .none
                }

                return Effect(value: .setLocation(location))

            case .didFailWithError(let error):
                return Effect(value: .error(AppError(error)))

            default:
                return .none
            }

        case .setLocation(let location):
            state.location = location
            return .none

        case let .setServiceStatus(status, enabled):
            state.clAuthorizationStatus = status
            state.locationServiceEnabled = enabled
            return .none
        }
    }
}
