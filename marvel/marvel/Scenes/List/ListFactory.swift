import UIKit
import Moya

enum ListFactory {
    static func make() -> UIViewController {
        let service = MarvelService(provider: MoyaProvider<MarvelEndpoint>())
        let presenter = ListPresenter()
        let interactor = ListInteractor(presenter: presenter, service: service)
        let viewController = ListViewController(interactor: interactor)
        
        presenter.viewController = viewController
        
        return viewController
    }
}
