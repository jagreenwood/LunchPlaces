//
//  Bundle+Key.swift
//  LunchPlaces
//
//  Created by Jeremy Greenwood on 5/10/22.
//

import Foundation

extension Bundle {
    static var googlePlacesKey: String {
        guard let key = Bundle.main.infoDictionary?["GOOGLE_PLACES_KEY"] as? String, !key.isEmpty else {
            fatalError("Please add your Google Place API Key to Config.xcconfig")
        }

        return key
    }
}
