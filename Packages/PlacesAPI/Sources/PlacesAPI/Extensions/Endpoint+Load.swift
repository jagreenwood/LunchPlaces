//
//  Endpoint+Load.swift
//  
//
//  Created by Jeremy Greenwood on 5/7/22.
//

import Combine
import Core
import Foundation
import TinyNetworking

public extension Endpoint {
    /// Loads data from an `Endpoint`
    /// - Parameter session: A type conforming to `Session`. defaults to an instance of `URLSession`
    /// - Returns: A Combine publisher which will either emit a value (success) or an error (failure)
    func load(_ session: Session = URLSession.shared) -> AnyPublisher<A, AppError> {
        AnyPublisher(
            session.load(self)
                // map the `Error` to our domain specific `AppError`
                .mapError { error in
                    // determine best error message
                    var errorMessage: String? {
                        switch error {
                        case is WrongStatusCodeError:
                            guard let data = (error as! WrongStatusCodeError).responseBody else {
                                return nil
                            }

                            return String(data: data, encoding: .utf8)
                        case is DecodingError:
                            return (error as! DecodingError).userDescription
                        default:
                            return nil
                        }
                    }

                    if let errorMessage = errorMessage {
                        return AppError(reason: errorMessage, underlyingError: error)
                    } else {
                        return AppError(error)
                    }
                }
        )
    }
}
