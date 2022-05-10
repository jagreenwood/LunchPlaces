//
//  HomeDomainTests.swift
//
//
//  Created by Jeremy Greenwood on 05/10/2022.
//

import ComposableArchitecture
import Overture
import XCTest
@testable import Home

extension HomeDomain.Environment {
    static let failing = Self()
}

final class HomeDomainTests: XCTestCase {
    func testName() throws {
        let store = TestStore(
            initialState: HomeDomain.State(),
            reducer: HomeDomain.reducer,
            environment: .mock(.failing))

        store.send(.onAppear) {
            $0.name = "Home"
        }
    }
}
