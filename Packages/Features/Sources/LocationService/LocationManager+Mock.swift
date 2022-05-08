//
//  Environment+Mock.swift
//  
//
//  Created by Jeremy Greenwood on 5/8/22.
//

import ComposableCoreLocation
import Foundation

extension LocationManager {
    static var mock: LocationManager = {
        var manager = LocationManager.failing
        manager.locationServicesEnabled = { true }
        manager.authorizationStatus = { CLAuthorizationStatus.authorizedWhenInUse }
        manager.requestLocation = { .none }
        manager.delegate = { .none }
        manager.requestWhenInUseAuthorization = { .none }

        return manager
    }()
}
