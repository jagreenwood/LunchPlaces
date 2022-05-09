//
//  AppDomain.swift
//
//
//  Created by Jeremy Greenwood on 05/07/2022.
//

import Common
import ComposableArchitecture
import Foundation
import LocationAccess

public struct AppDomain: Equatable {
    public struct State: Equatable {
        var locationAccessState: LocationAccessDomain.State?
        public var name: String

        public init(name: String = "") {
            self.name = name
        }
    }

    public enum Action: Equatable {
        case onAppear
        case locationAccess(LocationAccessDomain.Action)
    }

    public struct Environment {
        var locationAccessEnvironment: LocationAccessDomain.Environment

        public static var live = Self(locationAccessEnvironment: .live)
        public static var mock = Self(locationAccessEnvironment: .mock)
    }

    public static let reducer = Reducer<State, Action, SystemEnvironment<Environment>>.combine(
        LocationAccessDomain.reducer
            .optional()
            .pullback(
                state: \.locationAccessState,
                action: /Action.locationAccess,
                environment: { $0.map(\.locationAccessEnvironment) }),
        Reducer { state, action, _ in
            switch action {
            case .onAppear:
                state.name = "App"
                return .none
            case .locationAccess:
                return .none
            }
        }
    )
}
