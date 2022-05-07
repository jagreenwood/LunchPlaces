//
//  QueryParameters.swift
//  
//
//  Created by Jeremy Greenwood on 5/7/22.
//

import Foundation

public struct QueryParameters {
    let location: (lat: Double, long: Double)
    let pageToken: String?
    let radius: Double
    let type: String

    public init(
        location: (lat: Double, long: Double),
        pageToken: String?,
        radius: Double,
        type: String) {
            self.location = location
            self.pageToken = pageToken
            self.radius = radius
            self.type = type
        }
}

extension QueryParameters {
    var dictionaryRepresentation: [String: String] {
        ["latitude": String(location.lat),
         "longitude": String(location.long),
         "pagetoken": pageToken,
         "radius": String(radius),
         "type": type]
            .compactMapValues { $0 }
    }
}
