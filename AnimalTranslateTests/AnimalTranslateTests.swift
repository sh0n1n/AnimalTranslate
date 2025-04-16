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
    
    func testSelectPetSetsCorrectValue() {
            let controller = TranslateController()

            controller.selectPet(isCat: true)
            XCTAssertTrue(controller.isCatSelected, "Expected isCatSelected to be true when selecting a cat")

            controller.selectPet(isCat: false)
            XCTAssertFalse(controller.isCatSelected, "Expected isCatSelected to be false when selecting a dog")
        }
}
