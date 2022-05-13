//
//  PlaceListDomain.swift
//
//
//  Created by Jeremy Greenwood on 05/11/2022.
//

import Common
import Foundation
import Model
import PlaceRow

public struct PlaceListDomain: Equatable {
    public struct State: Equatable {
        public var places: [Place] {
            didSet {
                placeRowStates = IdentifiedArrayOf(
                    uniqueElements: places.map(PlaceRowDomain.State.init(place:)))
            }
        }

        var placeRowStates: IdentifiedArrayOf<PlaceRowDomain.State>

        public init(places: [Place] = []) {
            self.places = places
            self.placeRowStates = IdentifiedArrayOf(
                uniqueElements: places.map(PlaceRowDomain.State.init(place:)))
        }
    }

    public enum Action: Equatable {
        case onAppear
        case placeRow(id: String, action: PlaceRowDomain.Action)
    }

    public struct Environment {
        var placeRowEnvironment: PlaceRowDomain.Environment

        public static var live = Self(placeRowEnvironment: .live)
        public static var mock = Self(placeRowEnvironment: .mock)
    }

    public static let reducer = Reducer<State, Action, SystemEnvironment<Environment>>.combine(
        Reducer { _, action, _ in
            switch action {
            case .onAppear:
                return .none

            case .placeRow:
                return .none
            }
        },
        PlaceRowDomain.reducer.forEach(
            state: \.placeRowStates,
            action: /Action.placeRow(id:action:),
            environment: { $0.map(\.placeRowEnvironment) })
    )
}
