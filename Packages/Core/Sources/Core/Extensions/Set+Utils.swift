//
//  Set+Utils.swift
//  
//
//  Created by Jeremy Greenwood on 5/11/22.
//

import Foundation

public extension Set {
    mutating func toggle(_ element: Element) {
        if self.contains(element) {
            remove(element)
        } else {
            insert(element)
        }
    }
}
