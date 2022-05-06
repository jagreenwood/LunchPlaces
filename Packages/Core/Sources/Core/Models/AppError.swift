//
//  AppError.swift
//  
//
//  Created by Jeremy Greenwood on 5/5/22.
//

import Foundation

public struct AppError: Identifiable, Equatable, Error {
    public static func == (lhs: AppError, rhs: AppError) -> Bool {
        lhs.id == rhs.id && lhs.reason == rhs.reason
    }

    public let id: String
    public let reason: String
    public let underlyingError: Error?

    public init(id: String = UUID().uuidString, reason: String, underlyingError: Error? = nil) {
        self.id = id
        self.reason = reason
        self.underlyingError = underlyingError
    }

    public init(_ error: Error) {
        id = UUID().uuidString
        underlyingError = error
        reason = error.localizedDescription
    }
}
