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
        var alertState: AlertState<Action>?

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
        case error(AppError?)
        case onAppear
        case toggleFavorite
    }

    public struct Environment {
        var isFavorite: (Caching, String) throws -> Bool
        var toggleFavorite: (Caching, String) throws -> Void

        public static var live = Self(
            isFavorite: { cache, id throws in
                try FavoriteManager(cache: cache)
                    .isFavorite(id: id)
            },
            toggleFavorite: { cache, id throws in
                try FavoriteManager(cache: cache)
                    .toggleFavorite(id: id)
            })

        public static var mock = Self(
            isFavorite: { _, _ throws in false },
            toggleFavorite: { _, _ throws in })
    }

    public static let reducer = Reducer<State, Action, SystemEnvironment<Environment>> { state, action, environment in
        switch action {
        case .error(let error):
            state.alertState = AlertState(error)
            return .none

        case .onAppear:
            do {
                state.isFavorite = try environment.isFavorite(
                    environment.cache,
                    state.place.placeID)
            } catch let error as AppError {
                return Effect(value: .error(error))
            } catch {}

            return .none

        case .toggleFavorite:
            state.isFavorite.toggle()
            do {
                try environment.toggleFavorite(
                    environment.cache,
                    state.place.placeID
                )
            } catch let error as AppError {
                return Effect(value: .error(error))
            } catch {}

            return .none
        }
    }
}
