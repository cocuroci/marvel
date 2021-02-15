import Foundation

protocol BookmarksInteracting {
    func fetchList()
    func removeFromBookmarks(character: Character?)
}

final class BookmarksInteractor {
    private let presenter: BookmarksPresenting
    private let storage: BookmarksStorageProtocol
    private var characters = [Character]()
    
    init(presenter: BookmarksPresenting, storage: BookmarksStorageProtocol) {
        self.presenter = presenter
        self.storage = storage
    }
    
    private func updateList() {
        guard characters.count > 0 else {
            presenter.presentEmptyView()
            presenter.clearList()
            return
        }
        
        presenter.presentCharacters(characters)
    }
}

extension BookmarksInteractor: BookmarksInteracting {
    func fetchList() {
        let characters = storage.getCharacters()
        characters.isEmpty ? presenter.presentEmptyView() : presenter.presentCharacters(characters)
        self.characters = characters
    }
    
    func removeFromBookmarks(character: Character?) {
        guard let character = character, let index = characters.firstIndex(where: { $0.id == character.id }) else {
            return
        }
        
        storage.remove(character: character)
        characters.remove(at: index)
        
        updateList()
    }
}
