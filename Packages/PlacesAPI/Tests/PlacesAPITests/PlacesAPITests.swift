import XCTest
import TinyNetworking
@testable import PlacesAPI

final class PlacesAPITests: XCTestCase {
    enum Constants {
        static let baseURL = URL(string: "http://example.com")!
        static let apiKey = "abc123"
        static let queryTerm = "query-term"
    }

    let api = PlacesAPI(baseURL: Constants.baseURL, apiKey: Constants.apiKey)
    let parameters = QueryParameters(
        location: (10.0, 10.0),
        pageToken: "token",
        radius: 1.0,
        type: "type")

    func testNearbySearchEndpoint() {
        let endpoint = api.nearbySearch(parameters)

        XCTAssertEqual(
            endpoint.request.httpMethod,
            Endpoint<NSNull>.Method.get.rawValue)

        let actualUrlQueryItems = endpoint
            .request
            .url?
            .query?
            .components(separatedBy: "&")
            .sorted(by: { $0 < $1 })

        let expectedURLQueryItems = [
            "key=\(Constants.apiKey)",
            "latitude=\(parameters.location.lat)",
            "longitude=\(parameters.location.long)",
            "pagetoken=\(parameters.pageToken ?? "")",
            "radius=\(parameters.radius)",
            "type=\(parameters.type)"
        ]

        XCTAssertEqual(
            actualUrlQueryItems,
            expectedURLQueryItems)
    }

    func testTextSearchEndpoint() {
        let endpoint = api.textSearch(Constants.queryTerm, parameters: parameters)

        XCTAssertEqual(
            endpoint.request.httpMethod,
            Endpoint<NSNull>.Method.get.rawValue)

        let actualUrlQueryItems = endpoint
            .request
            .url?
            .query?
            .components(separatedBy: "&")
            .sorted(by: { $0 < $1 })

        let expectedURLQueryItems = [
            "key=\(Constants.apiKey)",
            "latitude=\(parameters.location.lat)",
            "longitude=\(parameters.location.long)",
            "pagetoken=\(parameters.pageToken ?? "")",
            "query=\(Constants.queryTerm)",
            "radius=\(parameters.radius)",
            "type=\(parameters.type)"
        ]

        XCTAssertEqual(
            actualUrlQueryItems,
            expectedURLQueryItems)
    }
}
