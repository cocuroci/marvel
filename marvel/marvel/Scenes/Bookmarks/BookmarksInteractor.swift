import Foundation

protocol BookmarksInteracting {
    var delegate: UpdatedCharacterDelegate? { get set }
    func fetchList()
    func didSelectCharacter(with indexPath: IndexPath)
    func removeFromBookmarks(character: Character?)
}

final class BookmarksInteractor {
    private let presenter: BookmarksPresenting
    private let storage: BookmarksStorageProtocol
    private var characters = [Character]()
    
    weak var delegate: UpdatedCharacterDelegate?
    
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
    
    func didSelectCharacter(with indexPath: IndexPath) {
        guard characters.indices.contains(indexPath.row) else {
            return
        }
        
        let character = characters[indexPath.row]
        presenter.didNextStep(action: .detail(character: character, delegate: self))
    }
    
    func removeFromBookmarks(character: Character?) {
        guard let character = character, let index = characters.firstIndex(where: { $0.id == character.id }) else {
            return
        }
        
        storage.remove(character: character)
        characters.remove(at: index)
        
        updateList()
        
        delegate?.updatedFavorite()
    }
}

extension BookmarksInteractor: UpdatedCharacterDelegate {
    func updatedFavorite() {
        self.characters = storage.getCharacters()
        updateList()
        delegate?.updatedFavorite()
    }
}
