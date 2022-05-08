//
//  LocationServiceDomainTests.swift
//
//
//  Created by Jeremy Greenwood on 05/08/2022.
//

import ComposableArchitecture
import Overture
import XCTest
@testable import LocationService

extension LocationServiceDomain.Environment {
    static let failing = Self(locationManager: .failing)
}

final class LocationServiceDomainTests: XCTestCase {}
