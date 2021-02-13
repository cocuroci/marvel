import Foundation

protocol ListPresenting {
    var viewController: ListDisplaying? { get set }
    func presentCharacters(_ characters: [Character])
}

final class ListPresenter {
    weak var viewController: ListDisplaying?
}

extension ListPresenter: ListPresenting {
    func presentCharacters(_ characters: [Character]) {
        viewController?.displayCharacters(characters)
    }
}
