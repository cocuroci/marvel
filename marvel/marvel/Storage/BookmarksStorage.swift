import Foundation

protocol BookmarksStorageProtocol {
    func save(character: Character)
    func remove(character: Character)
    func getCharacters() -> [Character]
    func idCharacters() -> [Int]
}

final class BookmarksStorage {
    private let localStorage: LocalStorageProtocol
    
    init(localStorage: LocalStorageProtocol = LocalStorage(forKey: "Bookmarks")) {
        self.localStorage = localStorage
    }
}

extension BookmarksStorage: BookmarksStorageProtocol {
    func save(character: Character) {
        localStorage.save(object: character)
    }
    
    func remove(character: Character) {
        localStorage.remove(object: character)
    }
    
    func getCharacters() -> [Character] {
        localStorage.getObjects()
    }
    
    func idCharacters() -> [Int] {
        let characters: [Character] = localStorage.getObjects()
        return characters.compactMap { $0.id }
    }
}
