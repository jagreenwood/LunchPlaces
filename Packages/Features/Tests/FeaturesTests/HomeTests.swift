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
        placeListEnvironment: .mock,
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

        store.send(.onAppear)
        store.receive(.locationService(.configure))
    }

    func testFetchLocation() {
        let store = TestStore(
            initialState: HomeDomain.State(),
            reducer: HomeDomain.reducer,
            environment: .mock(.failing))

        store.send(.fetchLocation) {
            $0.isLoading = true
        }
        store.receive(.locationService(.authorize))
        store.receive(.locationService(.getLocation))
        store.receive(.locationService(.configure))
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

        store.send(.fetchNearbyRestaurants) {
            $0.isLoading = true
        }
        store.receive(.setRestaurants(Mock.places)) {
            $0.isLoading = false
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
