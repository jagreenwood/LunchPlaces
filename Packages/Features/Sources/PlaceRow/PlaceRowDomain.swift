//
//  PlaceRowDomain.swift
//
//
//  Created by Jeremy Greenwood on 05/11/2022.
//

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
        public static var live = Self()
        public static var mock = Self()
    }

    public static let reducer = Reducer<State, Action, SystemEnvironment<Environment>> { state, action, _ in
        switch action {
        case .onAppear:
            return .none

        case .toggleFavorite:
            state.isFavorite.toggle()
            return .none
        }
    }
}
