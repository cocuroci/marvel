import Foundation

enum BookmarksFactory {
    static func make(delegate: UpdatedCharacterDelegate? = nil) -> BookmarksViewController {
        let storage = BookmarksStorage()
        let coordinator = BookmarksCoordinator()
        let presenter = BookmarksPresenter(coordinator: coordinator)
        let interactor = BookmarksInteractor(presenter: presenter, storage: storage)
        let viewController = BookmarksViewController(interactor: interactor)
        
        presenter.viewController = viewController
        coordinator.viewController = viewController
        interactor.delegate = delegate
        
        return viewController
    }
}
