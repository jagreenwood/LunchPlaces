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

extension AppDomain.Environment {
    static var failing = Self()
}

final class AppDomainTests: XCTestCase {
    func testName() throws {
        let store = TestStore(
            initialState: AppDomain.State(),
            reducer: AppDomain.reducer,
            environment: .mock(.failing))

        store.send(.onAppear) {
            $0.name = "App"
        }
    }
}
