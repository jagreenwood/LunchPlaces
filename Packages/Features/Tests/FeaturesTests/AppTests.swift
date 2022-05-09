//
//  AppDomainTests.swift
//
//
//  Created by Jeremy Greenwood on 05/07/2022.
//

import ComposableArchitecture
import Overture
import XCTest
@testable import App
@testable import LocationAccess

extension AppDomain.Environment {
    static var failing = Self(
        locationAccessEnvironment: .mock,
        locationServiceEnvironment: .mock)
}

final class AppDomainTests: XCTestCase {
    func testName() throws {
        let store = TestStore(
            initialState: AppDomain.State(),
            reducer: AppDomain.reducer.debug(),
            environment: .mock(update(.failing) { _ in

            }))

        store.send(.onAppear) {
            $0.name = "App"
        }
        store.receive(.locationService(.getServiceStatus))
        store.receive(.locationService(.setServiceStatus(.notDetermined, true))) {
            $0.locationAccessState = LocationAccessDomain.State(locationServiceState: $0.locationServiceState)
        }
    }
}
