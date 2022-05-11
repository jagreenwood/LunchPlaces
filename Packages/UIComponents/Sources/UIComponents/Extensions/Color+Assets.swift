//
//  Color+Assets.swift
//  
//
//  Created by Jeremy Greenwood on 5/7/22.
//

import SwiftUI

public extension Color {
    static let appPrimary = Color.primary
    static let appWhite = Color("appWhite", bundle: .assets)
    static let appBackground = appPrimary.opacity(0.05)
}
