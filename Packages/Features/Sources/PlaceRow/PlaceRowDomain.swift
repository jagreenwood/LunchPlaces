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
        public var id: String { place.placeID }
        public var place: Place

        public init(place: Place) {
            self.place = place
        }
    }

    public enum Action: Equatable {
        case onAppear
    }

    public struct Environment {
        public static var live = Self()
        public static var mock = Self()
    }

    public static let reducer = Reducer<State, Action, SystemEnvironment<Environment>> { state, action, _ in
        switch action {
        case .onAppear:
            return .none
        }
    }
}
