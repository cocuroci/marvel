import Foundation

protocol ListInteracting {
    func fetchList()
    func tryAgain()
    func didSelectCharacter(with indexPath: IndexPath)
    func didFavoriteCharacter(character: Character?)
}

final class ListInteractor {
    private let presenter: ListPresenting
    private let service: MarvelServicing
    private let bookmarks: BookmarksStorageProtocol
    private var characters = [Character]()
    
    init(presenter: ListPresenting, service: MarvelServicing, bookmarks: BookmarksStorageProtocol) {
        self.presenter = presenter
        self.service = service
        self.bookmarks = bookmarks
    }
    
    private func handleSuccess(_ characters: [Character]) {
        guard characters.count > 0 else {
            presenter.presentEmptyResultView()
            return
        }
        
        updateList(characters)
    }
    
    private func updateList(_ characters: [Character]) {
        let currentCharacters = characters.map {
            Character(with: $0, isFavorite: bookmarks.idCharacters().contains($0.id ?? 0))
        }
    
        presenter.presentCharacters(currentCharacters)
        self.characters = currentCharacters
    }
    
    private func handleError(_ error: ApiError) {
        switch error {
        case .internetFailure:
            presenter.presentNoInternetView()
        default:
            presenter.presentErrorView()
        }
    }
}

extension ListInteractor: ListInteracting {
    func fetchList() {
        presenter.presentLoader()
        
        service.list { [weak self] result in
            self?.presenter.hideLoader()

            switch result {
            case .success(let characters):
                self?.handleSuccess(characters)
            case .failure(let error):
                self?.handleError(error)
            }
        }
    }
    
    func tryAgain() {
        presenter.removeFeedbackView()
        fetchList()
    }
    
    func didSelectCharacter(with indexPath: IndexPath) {
        guard characters.indices.contains(indexPath.row) else {
            return
        }
        
        let character = characters[indexPath.row]
        presenter.didNextStep(action: .detail(character: character, delegate: self))
    }
    
    func didFavoriteCharacter(character: Character?) {
        guard let character = character, let index = characters.firstIndex(where: { $0.id == character.id }) else {
            return
        }
        
        let currentFavoriteValue = character.isFavorite ?? false
        characters[index] = Character(with: character, isFavorite: !currentFavoriteValue)
        currentFavoriteValue ? bookmarks.remove(character: character) : bookmarks.save(character: character)
        
        presenter.presentCharacters(characters)
    }
}

extension ListInteractor: DetailInteractorDelegate {
    func updatedFavorite() {
        updateList(characters)
    }
}
