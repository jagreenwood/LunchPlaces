//
//  FavoritesManager.swift
//  
//
//  Created by Jeremy Greenwood on 5/11/22.
//

import Cache
import Foundation

public struct FavoriteManager {
    private let cacheKey = "favorite"
    let cache: Caching

    public init(cache: Caching) {
        self.cache = cache
    }

    public func isFavorite(id: String) throws -> Bool {
        guard let favorites: [String] = try cache.object(key: cacheKey) else {
            return false
        }

        return favorites.contains(id)
    }

    public func toggleFavorite(id: String) throws {
        var favorites: Set<String> = try {
            guard let favorites: Set<String> = try cache.object(key: cacheKey) else {
                return []
            }

            return favorites
        }()

        favorites.toggle(id)
        try? cache.cache(favorites, key: cacheKey)
    }
}
