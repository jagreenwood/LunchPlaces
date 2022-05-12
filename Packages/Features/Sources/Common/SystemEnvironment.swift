//
//  SystemEnvironment.swift
//  
//
//  Created by Jeremy Greenwood on 5/7/22.
//

import Cache
import CombineSchedulers
import Foundation
import PlacesAPI

@dynamicMemberLookup
/// A type which holds global dependencies to be used by feature domains.
public struct SystemEnvironment<Environment> {
    public var cache: Caching
    public var environment: Environment
    public var mainQueue: AnySchedulerOf<DispatchQueue>
    public var placesAPI: PlacesAPI

    public init(
        cache: Caching,
        environment: Environment,
        mainQueue: AnySchedulerOf<DispatchQueue>,
        placesAPI: PlacesAPI) {
            self.cache = cache
            self.environment = environment
            self.mainQueue = mainQueue
            self.placesAPI = placesAPI
        }

    public static func mock(
        _ environment: Environment,
        cache: Caching = MockCache(),
        queue: AnySchedulerOf<DispatchQueue> = .immediate,
        placesAPI: PlacesAPI = PlacesAPI(baseURL: URL(string: "http://www.mockapi.foo")!, apiKey: "")) -> Self {
            Self(
                cache: cache,
                environment: environment,
                mainQueue: queue,
                placesAPI: placesAPI)
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
            cache: cache,
            environment: transform(environment),
            mainQueue: mainQueue,
            placesAPI: placesAPI)
    }
}

#if DEBUG
public struct MockCache: Caching {
    public init() {}
    public func cache<T>(_ object: T, key: String) throws where T: Decodable, T: Encodable {}
    public func object<T>(key: String) throws -> T? where T: Decodable, T: Encodable { nil }
}
#endif
