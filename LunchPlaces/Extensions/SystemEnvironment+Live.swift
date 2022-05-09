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
            environment: environment,
            mainQueue: DispatchQueue.main.eraseToAnyScheduler())
    }}
