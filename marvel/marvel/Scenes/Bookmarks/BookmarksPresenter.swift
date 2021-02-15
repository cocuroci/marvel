import Foundation

protocol BookmarksPresenting {
    var viewController: BookmarksDisplaying? { get set }
    func presentCharacters(_ characters: [Character])
    func presentEmptyView()
    func clearList()
    func didNextStep(action: BookmarksAction)
}

final class BookmarksPresenter {
    private let coordinator: BookmarksCoordinating
    weak var viewController: BookmarksDisplaying?
    
    init(coordinator: BookmarksCoordinating) {
        self.coordinator = coordinator
    }
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
    
    func didNextStep(action: BookmarksAction) {
        coordinator.perform(action: action)
    }
}
