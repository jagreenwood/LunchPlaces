//
//  LocationServiceDomainTests.swift
//
//
//  Created by Jeremy Greenwood on 05/08/2022.
//

@testable import LocationService
import Combine
import ComposableArchitecture
import ComposableCoreLocation
import CoreLocation
import Overture
import XCTest

extension LocationServiceDomain.Environment {
    static let failing = Self(locationManager: .failing)
}

final class LocationServiceDomainTests: XCTestCase {
    func testAuthorize() {
        let store = TestStore(
            initialState: LocationServiceDomain.State(),
            reducer: LocationServiceDomain.reducer,
            environment: update(.failing) {
                $0.locationManager.delegate = { Effect(value: .didChangeAuthorization(.authorizedWhenInUse)) }
                $0.locationManager.requestWhenInUseAuthorization = { .none }
                $0.locationManager.authorizationStatus = { CLAuthorizationStatus.authorizedWhenInUse }
                $0.locationManager.locationServicesEnabled = { true }
            })

        store.send(.authorize)
        store.receive(.locationManager(.didChangeAuthorization(.authorizedWhenInUse)))
        store.receive(.getServiceStatus)
        store.receive(.setServiceStatus(.authorizedWhenInUse, true)) {
            $0.clAuthorizationStatus = .authorizedWhenInUse
            $0.locationServiceEnabled = true
        }
    }

    func testGetLocation() {
        let location = Location(rawValue: CLLocation(latitude: 10.0, longitude: 10.0))
        let store = TestStore(
            initialState: LocationServiceDomain.State(),
            reducer: LocationServiceDomain.reducer,
            environment: .failing)

        store.environment.locationManager.requestLocation = {
            .fireAndForget {
                store.send(.locationManager(.didUpdateLocations([location])))
            }
        }

        store.send(.getLocation)
        store.receive(.setLocation(location)) {
            $0.location = location
        }
    }
}
