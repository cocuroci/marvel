import Foundation

protocol DetailInteracting {
    func showCharacter()
}

final class DetailInteractor {
    private let character: Character
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
}
