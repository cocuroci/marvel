import Foundation

protocol ListInteracting {
    func fetchList()
    func tryAgain()
    func didSelectCharacter(with indexPath: IndexPath)
}

final class ListInteractor {
    private let presenter: ListPresenting
    private let service: MarvelServicing
    private var characters = [Character]()
    
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
                guard characters.count > 0 else {
                    self?.presenter.presentEmptyResultView()
                    return
                }
                
                self?.presenter.presentCharacters(characters)
                self?.characters = characters
            case .failure(let error):
                self?.handleError(error)
            }
        }
    }
    
    func tryAgain() {
        presenter.removeFeedbackView()
        fetchList()
    }
    
    func didSelectCharacter(with indexPath: IndexPath) {
        guard characters.indices.contains(indexPath.row) else {
            return
        }
        
        let character = characters[indexPath.row]
        presenter.didNextStep(action: .detail(character: character))
    }
}
