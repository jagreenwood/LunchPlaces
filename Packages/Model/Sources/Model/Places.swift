//
//  Places.swift
//  
//
//  Created by Jeremy Greenwood on 5/5/22.
//

import Foundation

public struct Places: Codable, Equatable {
    public let errorMessage: String?
    public let nextPageToken: String?
    public let results: [Place]
    public let status: Status

    enum CodingKeys: String, CodingKey {
        case errorMessage = "error_message"
        case nextPageToken = "next_page_token"
        case results = "results"
        case status = "status"
    }

    public init(
        errorMessage: String?,
        nextPageToken: String?,
        results: [Place],
        status: Status) {
            self.errorMessage = errorMessage
            self.nextPageToken = nextPageToken
            self.results = results
            self.status = status
        }
}

public enum Status: String, Codable {
    case ok = "OK"
    case zeroResults = "ZERO_RESULTS"
    case invalidRequest = "INVALID_REQUEST"
    case overQueryLimit = "OVER_QUERY_LIMIT"
    case requestDenied = "REQUEST_DENIED"
    case unknownError = "UNKNOWN_ERROR"
}
