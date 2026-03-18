import Foundation

struct ArticleModelRTG: Codable, Identifiable, Hashable {
    let id: String
    let title: String
    let imageName: String
    let iconName: String
    let paragraphs: [String]
}
