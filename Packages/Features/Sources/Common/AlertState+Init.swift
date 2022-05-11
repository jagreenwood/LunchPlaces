//
//  AlertState+Init.swift
//  
//
//  Created by Jeremy Greenwood on 5/10/22.
//

import ComposableArchitecture

public extension AlertState {
    init?(_ appError: AppError?) {
        guard let error = appError else {
            return nil
        }

        self = AlertState(
            title: TextState("oh no!"),
            message: TextState(error.reason))
    }
}
