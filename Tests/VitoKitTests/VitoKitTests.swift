import XCTest
@testable import VitoKit

final class VitoKitTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let vito = Vito()
        Task {
            await vito.authorize()
        }
        //XCTAssertEqual(VitoKit().text, "Hello, World!")
    }
}
