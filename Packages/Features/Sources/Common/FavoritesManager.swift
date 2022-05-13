//
//  FavoritesManager.swift
//  
//
//  Created by Jeremy Greenwood on 5/11/22.
//

import Cache
import Foundation

/// A type to manage favorites. It is intialized with a type conforming to `Caching`
public struct FavoriteManager {
    private let cacheKey = "favorite"
    let cache: Caching

    public init(cache: Caching) {
        self.cache = cache
    }

    /// Determines whether an `id` is cached
    /// - Parameter id: A unique identifier
    /// - Returns: A `Bool` indicating whether the given `id` was previously cached
    public func isFavorite(id: String) throws -> Bool {
        guard let favorites: [String] = try cache.object(key: cacheKey) else {
            return false
        }

        return favorites.contains(id)
    }

    /// Toggles the cached state of `id`
    /// - Parameter id: A unique identifier
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
