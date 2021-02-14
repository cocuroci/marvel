import UIKit

enum DetailFactory {
    static func make(with character: Character) -> UIViewController {
        let presenter = DetailPresenter()
        let interactor = DetailInteractor(character: character, presenter: presenter)
        let viewController = DetailViewController(interactor: interactor)
        
        presenter.viewController = viewController
        
        return viewController
    }
}
