//
//  Place+ID.swift
//  
//
//  Created by Jeremy Greenwood on 5/11/22.
//

import struct Model.Place

extension Place: Identifiable {
    /// Add `Identifiable` conformance to `Place`
    public var id: String { placeID }
}
