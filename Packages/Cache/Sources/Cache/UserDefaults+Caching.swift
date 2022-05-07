//
//  UserDefaults+Caching.swift
//  
//
//  Created by Jeremy Greenwood on 5/6/22.
//

import Foundation

extension UserDefaults: Caching {
    public func cache<T>(_ object: T, key: String) throws where T: Decodable, T: Encodable {
        let data = try JSONEncoder().encode(object)
        set(data, forKey: key)
    }

    public func object<T>(key: String) throws -> T? where T: Decodable, T: Encodable {
        guard let data = data(forKey: key) else { return nil }
        return try JSONDecoder().decode(T.self, from: data)
    }
}
