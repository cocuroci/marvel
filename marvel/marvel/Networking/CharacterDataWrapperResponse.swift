import Foundation

struct CharacterDataWrapper: Decodable {
    let data: CharacterDataContainer?
}

struct CharacterDataContainer: Decodable {
    let result: [Character]?
}
