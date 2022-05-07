//
//  Session.swift
//  
//
//  Created by Jeremy Greenwood on 5/7/22.
//

import Combine
import Foundation
import TinyNetworking

/// A protocol to enable better test coverage
public protocol Session {
    func load<A>(_ endpoint: Endpoint<A>) -> AnyPublisher<A, Error>
}

extension URLSession: Session {}
