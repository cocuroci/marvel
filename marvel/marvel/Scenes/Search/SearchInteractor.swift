import Foundation

protocol SearchInteracting {
    func search(with name: String?)
    func didDismissSearch()
}

final class SearchInteractor {
    private let presenter: SearchPresenting
    private let service: MarvelServicing
    private var characters = [Character]()
    
    init(presenter: SearchPresenting, service: MarvelServicing) {
        self.presenter = presenter
        self.service = service
    }
    
    private func handleSuccess(_ characters: [Character]) {
        guard characters.count > 0 else {
            presenter.presentEmptyResultView()
            return
        }
        
        presenter.presentCharacters(characters)
        self.characters = characters
    }
    
    private func handleError(_ error: ApiError) {
        switch error {
        case .internetFailure: break
        default: break
        }
    }
}

extension SearchInteractor: SearchInteracting {
    func search(with name: String?) {
        guard let searchName = name, !searchName.isEmpty else {
            return
        }
        
        service.search(by: searchName) { [weak self] result in
            switch result {
            case .success(let result):
                self?.handleSuccess(result)
            case .failure(let error):
                self?.handleError(error)
            }
        }
    }
    
    func didDismissSearch() {
        presenter.resetView()
    }
}
