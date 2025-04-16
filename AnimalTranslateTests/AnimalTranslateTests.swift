import XCTest
@testable import AnimalTranslate

final class TranslateControllerTests: XCTestCase {
    func testToggleTranslationMode() {
        let controller = TranslateController()

        // By default, isPetToHuman should be true
        XCTAssertTrue(controller.isPetToHuman)

        // Toggle the mode
        controller.toggleTranslationMode()

        // Now it should be false
        XCTAssertFalse(controller.isPetToHuman)
    }
}
