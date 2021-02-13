import UIKit

enum ListFactory {
    static func make() -> UIViewController {
        let presenter = ListPresenter()
        let interactor = ListInteractor(presenter: presenter)
        let viewController = ListViewController(interactor: interactor)
        
        presenter.viewController = viewController
        
        return viewController
    }
}
