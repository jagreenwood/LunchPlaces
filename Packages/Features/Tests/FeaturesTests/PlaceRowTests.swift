//
//  PlaceRowDomainTests.swift
//
//
//  Created by Jeremy Greenwood on 05/11/2022.
//

import ComposableArchitecture
import Overture
import XCTest
@testable import PlaceRow

extension PlaceRowDomain.Environment {
    static let failing = Self()
}

final class PlaceRowDomainTests: XCTestCase {
    func testName() throws {
        let store = TestStore(
            initialState: PlaceRowDomain.State(),
            reducer: PlaceRowDomain.reducer,
            environment: .mock(.failing))

        store.send(.onAppear) {
            $0.name = "PlaceRow"
        }
    }
}
