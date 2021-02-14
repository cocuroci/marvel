import Foundation

protocol DetailInteracting {
    func showCharacter()
    func didFavoriteCharacter()
}

final class DetailInteractor {
    private var character: Character
    private let presenter: DetailPresenting
    
    init(character: Character, presenter: DetailPresenting) {
        self.character = character
        self.presenter = presenter
    }
}

extension DetailInteractor: DetailInteracting {
    func showCharacter() {
        presenter.presentName(character.name)
        presenter.presentImage(url: character.thumbnail?.url)
        presenter.presentDescription(character.description)
        character.isFavorite == true ? presenter.presentCharacterIsFavorite() : presenter.presentCharacterIsNotFavorite()
    }
    
    func didFavoriteCharacter() {
        let isFavorite = character.isFavorite ?? false
        character = Character(with: character, isFavorite: !isFavorite)
        character.isFavorite == true ? presenter.presentCharacterIsFavorite() : presenter.presentCharacterIsNotFavorite()
    }
}
