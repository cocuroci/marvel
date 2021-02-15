import Foundation

protocol DetailInteracting {
    var delegate: UpdatedCharacterDelegate? { get set }
    func showCharacter()
    func didFavoriteCharacter()
}

final class DetailInteractor {
    private var character: Character
    private let presenter: DetailPresenting
    private let bookmarks: BookmarksStorageProtocol
    weak var delegate: UpdatedCharacterDelegate?
    
    init(
        character: Character,
        presenter: DetailPresenting,
        bookmarks: BookmarksStorageProtocol
    ) {
        self.character = character
        self.presenter = presenter
        self.bookmarks = bookmarks
    }
    
    private func changeFavoriteStatus() {
        character.isFavorite == true ? presenter.presentCharacterIsFavorite() : presenter.presentCharacterIsNotFavorite()
    }
}

extension DetailInteractor: DetailInteracting {
    func showCharacter() {
        presenter.presentName(character.name)
        presenter.presentImage(url: character.thumbnail?.url)
        presenter.presentDescription(character.description)
        changeFavoriteStatus()
    }
    
    func didFavoriteCharacter() {
        let isFavorite = character.isFavorite ?? false
        
        character = Character(with: character, isFavorite: !isFavorite)
        isFavorite ? bookmarks.remove(character: character) : bookmarks.save(character: character)
        
        changeFavoriteStatus()
        
        delegate?.updatedFavorite()
    }
}
