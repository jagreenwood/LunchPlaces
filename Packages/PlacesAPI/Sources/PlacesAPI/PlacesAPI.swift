//
//  PlacesAPI.swift
//  
//
//  Created by Jeremy Greenwood on 5/7/22.
//

import Foundation
import Model
import TinyNetworking

/// The Portfolio type is primarily used to contruct instances of `JSONEndpoint`. Functionality can be
/// updated to add support for API authorization, authentication, url parameter, headers, etc.
public final class PlacesAPI {
    enum Constants {
        static let query = "query"
        static let key = "key"
    }

    enum Routes {
        case nearbySearch
        case textSearch

        var path: String {
            switch self {
            case .nearbySearch: return "/nearbysearch/json"
            case .textSearch: return "/textsearch/json"
            }
        }
    }

    let baseURL: URL
    let apiKey: String

    /// Initializer for Portfolio
    /// - Parameter baseURL: The base url for the API.
    public init(baseURL: URL, apiKey: String) {
        self.baseURL = baseURL
        self.apiKey = apiKey
    }

    /// - Parameter parameters: Parameters to send the google places api
    /// - Returns: An `Endpoint` representing the nearby search request
    public func nearbySearch(_ parameters: QueryParameters) -> Endpoint<[Place]> {
        var urlParameters = parameters.dictionaryRepresentation
        appendKey(&urlParameters)

        return Endpoint<Places>(
            json: .get,
            url: url(.nearbySearch),
            query: urlParameters)
        .map(\.results)
    }

    /// - Parameter parameters: Parameters to send the google places api
    /// - Returns: An `Endpoint` representing the text search request
    public func textSearch(_ text: String, parameters: QueryParameters) -> Endpoint<[Place]> {
        var urlParameters = parameters.dictionaryRepresentation
        appendKey(&urlParameters)
        urlParameters[Constants.query] = text

        return Endpoint<Places>(
            json: .get,
            url: url(.textSearch),
            query: urlParameters)
        .map(\.results)
    }
}

extension PlacesAPI {
    /// Convienence method to build urls
    /// - Parameter route: A `Route` enum item
    /// - Returns: A url with host and path
    func url(_ route: Routes) -> URL {
        baseURL.appendingPathComponent(route.path)
    }

    /// Adds the api to the given dictionary
    /// - Parameter parameters: A dictonary of parameters
    func appendKey(_ parameters: inout [String: String]) {
        parameters[Constants.key] = apiKey
    }
}
