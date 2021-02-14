import Foundation

struct Character: Codable, Identifiable {
    let id: Int?
    let name: String?
    let description: String?
    let thumbnail: CharacterImage?
    let isFavorite: Bool?
    
    init(id: Int?, name: String?, description: String?, thumbnail: CharacterImage?, isFavorite: Bool = false) {
        self.id = id
        self.name = name
        self.description = description
        self.thumbnail = thumbnail
        self.isFavorite = isFavorite
    }
    
    init(with character: Character, isFavorite: Bool) {
        self.id = character.id
        self.name = character.name
        self.description = character.description
        self.thumbnail = character.thumbnail
        self.isFavorite = isFavorite
    }
}
