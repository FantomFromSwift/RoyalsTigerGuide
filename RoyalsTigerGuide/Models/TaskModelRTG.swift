import Foundation

struct TaskStepModelRTG: Codable, Identifiable, Hashable {
    var id: Int { stepNumber }
    let stepNumber: Int
    let title: String
    let description: String
}

struct TaskModelRTG: Codable, Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let imageName: String
    let iconName: String
    let steps: [TaskStepModelRTG]
}
