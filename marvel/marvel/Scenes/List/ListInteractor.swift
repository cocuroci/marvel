import Foundation

protocol ListInteracting {
    func fetchList()
    func tryAgain()
}

final class ListInteractor {
    private let presenter: ListPresenting
    private let service: MarvelServicing
    
    init(presenter: ListPresenting, service: MarvelServicing) {
        self.presenter = presenter
        self.service = service
    }
    
    private func handleError(_ error: ApiError) {
        switch error {
        case .internetFailure:
            presenter.presentNoInternetView()
        default:
            presenter.presentErrorView()
        }
    }
}

extension ListInteractor: ListInteracting {
    func fetchList() {
        presenter.presentLoader()
        
        service.list { [weak self] result in
            self?.presenter.hideLoader()

            switch result {
            case .success(let characters):
                self?.presenter.presentCharacters(characters)
            case .failure(let error):
                self?.handleError(error)
            }
        }
    }
    
    func tryAgain() {
        presenter.removeFeedbackView()
        fetchList()
    }
}
