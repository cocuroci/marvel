import UIKit

enum DetailFactory {
    static func make(with character: Character, delegate: DetailInteractorDelegate? = nil) -> UIViewController {
        let presenter = DetailPresenter()
        let bookmarks = BookmarksStorage()
        let interactor = DetailInteractor(character: character, presenter: presenter, bookmarks: bookmarks)
        let viewController = DetailViewController(interactor: interactor)
        
        presenter.viewController = viewController
        interactor.delegate = delegate
        
        return viewController
    }
}
