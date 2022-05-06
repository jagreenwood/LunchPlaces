import XCTest
@testable import Mock

final class MockTests: XCTestCase {
    func testPlaces() throws {
        // will throw an exception and fail if decode fails do to `!`
        _ = Mock.places
    }
}
