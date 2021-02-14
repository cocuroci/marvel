import UIKit
import Moya

enum ListFactory {
    static func make() -> UIViewController {
        let service = MarvelService(provider: MoyaProvider<MarvelEndpoint>())
        let coordinator = ListCoordinator()
        let presenter = ListPresenter(coordinator: coordinator)
        let interactor = ListInteractor(presenter: presenter, service: service)
        let viewController = ListViewController(interactor: interactor)
        
        coordinator.viewController = viewController
        presenter.viewController = viewController
        
        return viewController
    }
}
