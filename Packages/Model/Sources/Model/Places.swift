//
//  Places.swift
//  
//
//  Created by Jeremy Greenwood on 5/5/22.
//

import Foundation

public struct Places: Codable, Equatable {
    public let nextPageToken: String?
    public let results: [Place]
    public let status: String

    enum CodingKeys: String, CodingKey {
        case nextPageToken = "next_page_token"
        case results = "results"
        case status = "status"
    }

    public init(
        nextPageToken: String?,
        results: [Place],
        status: String) {
            self.nextPageToken = nextPageToken
            self.results = results
            self.status = status
        }
}
