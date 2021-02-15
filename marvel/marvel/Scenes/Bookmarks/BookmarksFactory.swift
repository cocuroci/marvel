import Foundation

enum BookmarksFactory {
    static func make(delegate: UpdatedCharacterDelegate? = nil) -> BookmarksViewController {
        let storage = BookmarksStorage()
        let presenter = BookmarksPresenter()
        let interactor = BookmarksInteractor(presenter: presenter, storage: storage)
        let viewController = BookmarksViewController(interactor: interactor)
        
        presenter.viewController = viewController
        interactor.delegate = delegate
        
        return viewController
    }
}
