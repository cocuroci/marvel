import Foundation

protocol DetailPresenting {
    var viewController: DetailDisplaying? { get set }
    func presentCharacter(_ character: Character)
}

final class DetailPresenter {
    weak var viewController: DetailDisplaying?
}

extension DetailPresenter: DetailPresenting {
    func presentCharacter(_ character: Character) {
        viewController?.displayCharacter(character)
    }
}
