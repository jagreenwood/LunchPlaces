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

struct LocationServiceDomain: Equatable {
    struct State: Equatable {
        var authorizationStatus: CLAuthorizationStatus = .notDetermined
        var error: AppError? = nil
        var location: Location? = nil
        var locationServiceEnabled: Bool = false
    }

    enum Action: Equatable {
        case authorize
        case error(_ error: AppError?)
        case getLocation
        case getServiceStatus
        case locationManager(LocationManager.Action)
        case setLocation(Location)
        case setServiceStatus(CLAuthorizationStatus, Bool)
    }

    struct Environment {
        var locationManager: LocationManager

        static let live = Self(
            locationManager: .live)

        static let mock = Self(
            locationManager: .mock)
    }

    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
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
            case .didChangeAuthorization(.authorizedWhenInUse),
                    .didChangeAuthorization(.authorizedAlways):

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
            state.authorizationStatus = status
            state.locationServiceEnabled = enabled
            return .none
        }
    }
}

