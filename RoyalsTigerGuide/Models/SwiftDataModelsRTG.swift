import Foundation
import SwiftData

@Model
final class FavoriteItemRTG {
    var itemId: String
    var itemType: String
    var itemTitle: String
    var itemImage: String
    var dateAdded: Date

    init(itemId: String, itemType: String, itemTitle: String, itemImage: String, dateAdded: Date = Date()) {
        self.itemId = itemId
        self.itemType = itemType
        self.itemTitle = itemTitle
        self.itemImage = itemImage
        self.dateAdded = dateAdded
    }
}

@Model
final class JournalEntryRTG {
    var entryId: String
    var title: String
    var content: String
    var dateCreated: Date
    var mood: String
    var tigerSpecies: String

    init(entryId: String = UUID().uuidString, title: String, content: String, dateCreated: Date = Date(), mood: String, tigerSpecies: String) {
        self.entryId = entryId
        self.title = title
        self.content = content
        self.dateCreated = dateCreated
        self.mood = mood
        self.tigerSpecies = tigerSpecies
    }
}

@Model
final class TaskCompletionRTG {
    var taskId: String
    var taskTitle: String
    var dateCompleted: Date
    var stepsCompleted: Int

    init(taskId: String, taskTitle: String, dateCompleted: Date = Date(), stepsCompleted: Int) {
        self.taskId = taskId
        self.taskTitle = taskTitle
        self.dateCompleted = dateCompleted
        self.stepsCompleted = stepsCompleted
    }
}

@Model
final class QuizResultRTG {
    var quizId: String
    var score: Int
    var totalQuestions: Int
    var dateCompleted: Date

    init(quizId: String = UUID().uuidString, score: Int, totalQuestions: Int, dateCompleted: Date = Date()) {
        self.quizId = quizId
        self.score = score
        self.totalQuestions = totalQuestions
        self.dateCompleted = dateCompleted
    }
}
