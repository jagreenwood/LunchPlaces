//
//  LocationAccessDomainTests.swift
//
//
//  Created by Jeremy Greenwood on 05/08/2022.
//

import ComposableArchitecture
import Overture
import XCTest
@testable import LocationAccess
@testable import LocationService

extension LocationAccessDomain.Environment {
    static let failing = Self(
        locationServiceEnvironment: .mock
    )
}

final class LocationAccessDomainTests: XCTestCase {
    func testOnAppear() {
        let store = TestStore(
            initialState: LocationAccessDomain.State(),
            reducer: LocationAccessDomain.reducer,
            environment: .mock(.failing))

        store.send(.onAppear)
        store.receive(.locationService(.getServiceStatus))
        store.receive(.locationService(.setServiceStatus(.notDetermined, true))) {
            $0.locationServiceState.clAuthorizationStatus = .notDetermined
            $0.locationServiceState.locationServiceEnabled = true
        }
    }

    func testConfirmAction() {
        let store = TestStore(
            initialState: LocationAccessDomain.State(),
            reducer: LocationAccessDomain.reducer,
            environment: .mock(.failing))

        store.send(.didSelectConfirm)
        store.receive(.locationService(.authorize))
    }
}
