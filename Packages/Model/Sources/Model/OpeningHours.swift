//
//  OpeningHours.swift
//  
//
//  Created by Jeremy Greenwood on 5/5/22.
//

import Foundation

public struct OpeningHours: Codable, Equatable {
    public let openNow: Bool

    enum CodingKeys: String, CodingKey {
        case openNow = "open_now"
    }

    public init(openNow: Bool) {
        self.openNow = openNow
    }
}
