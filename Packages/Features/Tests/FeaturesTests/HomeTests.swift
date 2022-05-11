//
//  HomeDomainTests.swift
//
//
//  Created by Jeremy Greenwood on 05/10/2022.
//

import ComposableArchitecture
import ComposableCoreLocation
import Overture
import Mock
import XCTest
@testable import Home

extension HomeDomain.Environment {
    static let failing = Self(
        locationServiceEnvironment: .mock,
        nearbySearch: { _, _ in .failing("Uncallable") },
        textSearch: { _, _, _ in .failing("Uncallable") }
    )
}

final class HomeDomainTests: XCTestCase {
    func testOnAppear() {
        let store = TestStore(
            initialState: HomeDomain.State(),
            reducer: HomeDomain.reducer,
            environment: .mock(.failing))

        store.send(.onAppear) {
            $0.name = "Home"
        }
        store.receive(.locationService(.configure))
    }

    func testFetchLocation() {
        let store = TestStore(
            initialState: HomeDomain.State(),
            reducer: HomeDomain.reducer,
            environment: .mock(.failing))

        store.send(.fetchLocation)
        store.receive(.locationService(.getLocation))
    }

    func testFetchNearbyRestaurantsNoLocation() {
        let store = TestStore(
            initialState: HomeDomain.State(),
            reducer: HomeDomain.reducer,
            environment: .mock(.failing))

        store.send(.fetchNearbyRestaurants)
    }

    func testFetchNearbyRestaurants() {
        let state = update(HomeDomain.State()) {
            $0.locationServiceState.location = Location(
                coordinate: CLLocationCoordinate2D(
                    latitude: 10.0,
                    longitude: 10.0))
        }

        let store = TestStore(
            initialState: state,
            reducer: HomeDomain.reducer,
            environment: .mock(update(.failing) {
                $0.nearbySearch = { _, _ in Effect(value: Mock.places) }
            }))

        store.send(.fetchNearbyRestaurants)
        store.receive(.setRestaurants(Mock.places)) {
            $0.places = Mock.places
        }
    }

    func testToggleMap() {
        let store = TestStore(
            initialState: HomeDomain.State(),
            reducer: HomeDomain.reducer,
            environment: .mock(.failing))

        store.send(.toggleMap) {
            $0.showMap = true
        }
    }
}
