//
//  Caching.swift
//  
//
//  Created by Jeremy Greenwood on 5/6/22.
//

import Foundation

public protocol Caching {
    func cache<T: Codable>(_ object: T, key: String) throws
    func object<T: Codable>(key: String) throws -> T?
}
