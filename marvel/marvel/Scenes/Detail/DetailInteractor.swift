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
        presenter.presentCharacter(character)
    }
}
