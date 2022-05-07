//
//  SystemEnvironment.swift
//  
//
//  Created by Jeremy Greenwood on 5/7/22.
//

import CombineSchedulers
import Foundation

@dynamicMemberLookup
/// A type which holds global dependencies to be used by feature domains.
public struct SystemEnvironment<Environment> {
    public var environment: Environment
    public var mainQueue: AnySchedulerOf<DispatchQueue>

    public init(
        environment: Environment,
        mainQueue: AnySchedulerOf<DispatchQueue>) {
            self.environment = environment
            self.mainQueue = mainQueue
        }

    public static func mock(
        _ environment: Environment,
        queue: AnySchedulerOf<DispatchQueue> = .immediate) -> Self {
            Self(
                environment: environment,
                mainQueue: queue)
        }

    /// A convenience dynamic member lookup allowing for simplified callsite semantics, effectively omitting "environment" when accessing a member of `Environment`
    public subscript<Dependency>(
        dynamicMember keyPath: WritableKeyPath<Environment, Dependency>
    ) -> Dependency {
        get { self.environment[keyPath: keyPath] }
        set { self.environment[keyPath: keyPath] = newValue }
    }

    /// Maps the current global `SystemEnvironment` to a new instance with a difference local `Environment`
    /// - Parameter transform: Mapping function which transforms the current local `Environment` to a new `Environment`
    /// - Returns: A new instance of `SystemEnvironment`
    public func map<NewEnvironment>(
        _ transform: @escaping (Environment) -> NewEnvironment
    ) -> SystemEnvironment<NewEnvironment> {
        .init(
            environment: transform(environment),
            mainQueue: mainQueue)
    }
}
