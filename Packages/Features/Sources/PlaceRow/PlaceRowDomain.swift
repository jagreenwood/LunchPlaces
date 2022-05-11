//
//  PlaceRowDomain.swift
//
//
//  Created by Jeremy Greenwood on 05/11/2022.
//

import Common
import ComposableArchitecture
import Foundation

public struct PlaceRowDomain: Equatable {
    public struct State: Equatable {
        public var name: String

        public init(name: String = "") {
            self.name = name
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
            state.name = "PlaceRow"
            return .none
        }
    }
}
