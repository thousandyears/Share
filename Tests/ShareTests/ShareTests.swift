import XCTest
@testable import Share

final class ShareTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Share().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
