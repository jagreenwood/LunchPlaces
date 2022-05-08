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

extension LocationAccessDomain.Environment {
    static let failing = Self()
}

final class LocationAccessDomainTests: XCTestCase {
    func testName() throws {
        let store = TestStore(
            initialState: LocationAccessDomain.State(),
            reducer: LocationAccessDomain.reducer,
            environment: .mock(.failing))

        store.send(.onAppear) {
            $0.name = "LocationAccess"
        }
    }
}
