//
//  PlaceRowDomainTests.swift
//
//
//  Created by Jeremy Greenwood on 05/11/2022.
//

import ComposableArchitecture
import Overture
import Mock
import XCTest
@testable import PlaceRow

extension PlaceRowDomain.Environment {
    static let failing = Self(
        isFavorite: { _, _ throws in fatalError("Uncallable") },
        toggleFavorite: { _, _ throws in fatalError("Uncallable") })
}

final class PlaceRowDomainTests: XCTestCase {
    func testOnAppear() throws {
        let store = TestStore(
            initialState: PlaceRowDomain.State(
                place: Mock.places[0]),
            reducer: PlaceRowDomain.reducer,
            environment: .mock(update(.failing) {
                $0.isFavorite = { _, _ in true }
            }))

        store.send(.onAppear) {
            $0.isFavorite = true
        }
    }

    func testToggleFavorite() {
        let store = TestStore(
            initialState: PlaceRowDomain.State(
                place: Mock.places[0]),
            reducer: PlaceRowDomain.reducer,
            environment: .mock(update(.failing) {
                $0.toggleFavorite = { _, _ in }
            }))

        store.send(.toggleFavorite) {
            $0.isFavorite = true
        }
    }
}
