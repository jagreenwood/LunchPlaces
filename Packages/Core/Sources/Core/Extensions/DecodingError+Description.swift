//
//  DecodingError+Description.swift
//  
//
//  Created by Jeremy Greenwood on 5/7/22.
//

import Foundation

extension DecodingError.Context {
    var codingPathStringRepresentation: String {
        codingPath.map(\.stringValue).joined(separator: ".")
    }
}

public extension DecodingError {
    /// A convience discription of _why_ decoding failed.
    var userDescription: String {
        switch self {
        case .dataCorrupted(let context):
            return context.debugDescription
        case let .keyNotFound(key, context):
            return "The JSON attribute `\(context.codingPathStringRepresentation).\(key.stringValue)` is missing."
        case let .typeMismatch(type, context):
            return "The JSON attribute `\(context.codingPathStringRepresentation)` was not expected type \(type)."
        case let .valueNotFound(_, context):
            return "The JSON attribute `\(context.codingPathStringRepresentation)` is null."
        @unknown default:
            return localizedDescription
        }
    }
}
