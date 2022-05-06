//
//  Geometry.swift
//  
//
//  Created by Jeremy Greenwood on 5/5/22.
//

import Foundation

public struct Geometry: Codable, Equatable {
    public let location: Location

    enum CodingKeys: String, CodingKey {
        case location = "location"
    }

    public init(location: Location) {
        self.location = location
    }
}
