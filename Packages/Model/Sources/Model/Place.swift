//
//  Place.swift
//  
//
//  Created by Jeremy Greenwood on 5/5/22.
//

import Foundation

public struct Place: Codable, Equatable {
    public let businessStatus: BusinessStatus?
    public let formattedAddress: String?
    public let geometry: Geometry
    public let name: String
    public let openingHours: OpeningHours
    public let placeID: String
    public let priceLevel: Int?
    public let rating: Double?
    public let userRatingsTotal: Int?

    enum CodingKeys: String, CodingKey {
        case businessStatus = "business_status"
        case formattedAddress = "formatted_address"
        case geometry = "geometry"
        case name = "name"
        case openingHours = "opening_hours"
        case placeID = "place_id"
        case priceLevel = "price_level"
        case rating = "rating"
        case userRatingsTotal = "user_ratings_total"
    }

    public init(
        businessStatus: BusinessStatus?,
        formattedAddress: String?,
        geometry: Geometry,
        name: String,
        openingHours: OpeningHours,
        placeID: String,
        priceLevel: Int?,
        rating: Double?,
        userRatingsTotal: Int?) {
            self.businessStatus = businessStatus
            self.formattedAddress = formattedAddress
            self.geometry = geometry
            self.name = name
            self.openingHours = openingHours
            self.placeID = placeID
            self.priceLevel = priceLevel
            self.rating = rating
            self.userRatingsTotal = userRatingsTotal
        }
}

public enum BusinessStatus: String, Codable {
    case operational = "OPERATIONAL"
    case closedTemporarily = "CLOSED_TEMPORARILY"
    case closedPermanently = "CLOSED_PERMANENTLY"
}
