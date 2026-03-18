import Foundation

struct TigerTraitsRTG: Codable, Hashable {
    let strength: Int
    let speed: Int
    let stealth: Int
    let swimming: Int
    let endurance: Int
}

struct TigerSpeciesModelRTG: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let scientificName: String
    let habitat: String
    let region: String
    let population: String
    let status: String
    let description: String
    let imageName: String
    let traits: TigerTraitsRTG
}
