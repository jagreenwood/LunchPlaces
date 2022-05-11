//
//  SystemEnvironment+Live.swift
//  LunchPlaces
//
//  Created by Jeremy Greenwood on 5/9/22.
//

import Common

extension SystemEnvironment {
    static func live(_ environment: Environment) -> Self {
        Self(
            cache: UserDefaults.standard,
            environment: environment,
            mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
            placesAPI: PlacesAPI(
                baseURL: URL(string: "https://maps.googleapis.com/maps/api/place")!,
                apiKey: Bundle.googlePlacesKey))
    }}
