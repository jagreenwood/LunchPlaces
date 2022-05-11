//
//  Publisher+Utils.swift
//  
//
//  Created by Jeremy Greenwood on 5/10/22.
//

import Combine
import ComposableArchitecture
import Core

public extension Publisher where Self.Failure == AppError {

    /// Handle Combine output streams and convert them in to an `Effect` TCA reducer consumption
    /// - Parameters:
    ///   - scheduler: The dispatch queue to process results on
    ///   - success: The success handler, passing in upstream output
    ///   - failure: The failure handler, passing in an upstream error
    /// - Returns: An `Effect` to be used with TCA
    func flatMap<Action>(
        scheduler: AnySchedulerOf<DispatchQueue>,
        success: @escaping (Output) -> (Effect<Action, Never>),
        failure: @escaping (Failure) -> (Effect<Action, Never>)) -> Effect<Action, Never> {
            return self
                .catchToEffect()
                .receive(on: scheduler)
                .flatMap { result -> Effect<Action, Never> in
                    switch result {
                    case .success(let response):
                        return success(response)
                    case .failure(let error):
                        return failure(error)
                    }
                }.eraseToEffect()
        }

    /// Handle Combine output streams and convert them in to an `Effect` TCA reducer consumption
    /// - Parameters:
    ///   - scheduler: The dispatch queue to process results on
    ///   - success: The success handler, passing in upstream output
    ///   - failure: The failure handler, passing in an upstream error
    /// - Returns: An `Effect` to be used with TCA
    func map<Action>(
        scheduler: AnySchedulerOf<DispatchQueue>,
        success: @escaping (Output) -> (Action),
        failure: @escaping (Failure) -> (Action)) -> Effect<Action, Never> {
            return self
                .catchToEffect()
                .receive(on: scheduler)
                .flatMap { result -> Effect<Action, Never> in
                    switch result {
                    case .success(let response):
                        return Effect(value: success(response))
                    case .failure(let error):
                        return Effect(value: failure(error))
                    }
                }.eraseToEffect()
        }
}
