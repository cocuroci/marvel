import Foundation
@testable import marvel

final class BookmarksSpy: BookmarksStorageProtocol {
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
    
    func getCharacters() -> [Character] {
        []
    }
    
    func idCharacters() -> [Int] {
        []
    }
}
