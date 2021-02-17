import UIKit
import Moya

enum SearchFactory {
    static func make(delegate: SearchDelegate? = nil) -> SearchViewController {
        let service = MarvelService(provider: MoyaProvider<MarvelEndpoint>())
        let presenter = SearchPresenter()
        let interactor = SearchInteractor(presenter: presenter, service: service)
        let viewController = SearchViewController(interactor: interactor)
        
        presenter.viewController = viewController
        interactor.delegate = delegate
        
        return viewController
    }
}
