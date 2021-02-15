import Foundation

protocol BookmarksPresenting {
    var viewController: BookmarksDisplaying? { get set }
    func presentCharacters(_ characters: [Character])
    func presentEmptyView()
    func clearList()
}

final class BookmarksPresenter {
    weak var viewController: BookmarksDisplaying?
}

extension BookmarksPresenter: BookmarksPresenting {
    func presentCharacters(_ characters: [Character]) {
        viewController?.displayCharacters(characters)
    }
    
    func presentEmptyView() {
        viewController?.displayEmptyView(text: "Nenhum personagem favoritado", imageName: "star")
    }
    
    func clearList() {
        viewController?.clearList()
    }
}
