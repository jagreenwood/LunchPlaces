//
//  PlaceRowDomain.swift
//
//
//  Created by Jeremy Greenwood on 05/11/2022.
//

import Cache
import Common
import ComposableArchitecture
import Foundation
import Model

public struct PlaceRowDomain: Equatable {
    public struct State: Equatable, Identifiable {
        static let maxRating = 5

        public var id: String { place.placeID }
        public var place: Place
        public var isFavorite: Bool

        public init(place: Place, isFavorite: Bool) {
            self.place = place
            self.isFavorite = isFavorite
        }

        public init(place: Place) {
            self.place = place
            self.isFavorite = false
        }

        func showValue<Value>(_ keypath: KeyPath<Place, Value?>) -> Bool {
            place[keyPath: keypath] != nil
        }

        var ratingValue: Int {
            guard let rating = place.rating else {
                return 0
            }

            return Int(rating.rounded())
        }

    }

    public enum Action: Equatable {
        case onAppear
        case toggleFavorite
    }

    public struct Environment {
        var isFavorite: (Caching, String) -> Bool
        var toggleFavorite: (Caching, String) -> Void

        public static var live = Self(
            isFavorite: { cache, id in
                FavoriteManager(cache: cache)
                    .isFavorite(id: id)
            },
            toggleFavorite: { cache, id in
                FavoriteManager(cache: cache)
                    .toggleFavorite(id: id)
            })

        public static var mock = Self(
            isFavorite: { _, _ in false },
            toggleFavorite: { _, _ in })
    }

    public static let reducer = Reducer<State, Action, SystemEnvironment<Environment>> { state, action, environment in
        switch action {
        case .onAppear:
            state.isFavorite = environment.isFavorite(
                environment.cache,
                state.place.placeID)
            return .none

        case .toggleFavorite:
            state.isFavorite.toggle()
            environment.toggleFavorite(
                environment.cache,
                state.place.placeID
            )
            return .none
        }
    }
}
