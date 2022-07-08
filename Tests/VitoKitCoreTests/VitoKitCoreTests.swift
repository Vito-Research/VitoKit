@testable import VitoKitCore
import XCTest

final class VitoKitCoreTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Vito(selectedTypes: [.Vitals]).accessToken, "Hello, World!")
    }
}
