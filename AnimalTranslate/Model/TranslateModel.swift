import Foundation

// Model for translating
class TranslateModel {
    //Translating simulation
    func processTranslation(_ text: String, isCatSelected: Bool) -> String {
        if isCatSelected {
            return "I'm hungry, feed me!"
        } else {
            return "What are you doing human?"
        }
    }
}

