//
//  Location.swift
//  
//
//  Created by Jeremy Greenwood on 5/5/22.
//

import Foundation

public struct Location: Codable, Equatable {
    public let lat: Double
    public let lng: Double

    enum CodingKeys: String, CodingKey {
        case lat = "lat"
        case lng = "lng"
    }

    public init(lat: Double, lng: Double) {
        self.lat = lat
        self.lng = lng
    }
}
