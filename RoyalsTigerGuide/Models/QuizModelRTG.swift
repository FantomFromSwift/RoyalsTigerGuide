import Foundation

struct QuizQuestionModelRTG: Codable, Identifiable, Hashable {
    let id: String
    let question: String
    let options: [String]
    let correctIndex: Int
    let explanation: String
}
