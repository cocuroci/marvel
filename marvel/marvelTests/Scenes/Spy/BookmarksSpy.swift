import Foundation
@testable import marvel

final class BookmarksSpy: BookmarksStorageProtocol {
    
    private let characters: [Character]
    
    init(characters: [Character] = []) {
        self.characters = characters
    }
    
    // MARK: - save
    private(set) var saveCount = 0
    private(set) var savedCharacter: Character?
    
    func save(character: Character) {
        saveCount += 1
        savedCharacter = character
    }
    
    // MARK: - remove
    private(set) var removeCount = 0
    private(set) var removedCharacter: Character?
    
    func remove(character: Character) {
        removeCount += 1
        removedCharacter = character
    }
    
    // MARK: - getCharacters
    private(set) var getCharactersCount = 0
    
    func getCharacters() -> [Character] {
        getCharactersCount += 1
        return characters
    }
    
    // MARK: - idCharacters
    private(set) var idCharactersCount = 0
    
    func idCharacters() -> [Int] {
        idCharactersCount += 1
        return characters.compactMap { $0.id }
    }
}
