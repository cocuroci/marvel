import Foundation

struct Character: Codable, Identifiable {
    let id: Int?
    let name: String?
    let description: String?
    let thumbnail: CharacterImage?
}
