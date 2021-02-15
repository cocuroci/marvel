import Foundation

enum BookmarksFactory {
    static func make() -> BookmarksViewController {
        let storage = BookmarksStorage()
        let presenter = BookmarksPresenter()
        let interactor = BookmarksInteractor(presenter: presenter, storage: storage)
        let viewController = BookmarksViewController(interactor: interactor)
        
        presenter.viewController = viewController
        
        return viewController
    }
}
