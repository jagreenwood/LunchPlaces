//
//  PlaceListDomainTests.swift
//
//
//  Created by Jeremy Greenwood on 05/11/2022.
//

import ComposableArchitecture
import Overture
import XCTest
@testable import PlaceList

extension PlaceListDomain.Environment {
    static let failing = Self(
        placeRowEnvironment: .mock
    )
}

final class PlaceListDomainTests: XCTestCase {
    func testOnAppear() throws {
        let store = TestStore(
            initialState: PlaceListDomain.State(),
            reducer: PlaceListDomain.reducer,
            environment: .mock(.failing))

        store.send(.onAppear)
    }
}
