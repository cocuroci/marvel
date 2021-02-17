import Foundation

protocol SearchInteracting {
    var delegate: SearchDelegate? { get set }
    func search(with name: String?)
    func didSelectCharacter(with indexPath: IndexPath)
    func didDismissSearch()
}

protocol SearchDelegate: AnyObject {
    func didSelectedCharacter(_ character: Character)
}

final class SearchInteractor {
    private let presenter: SearchPresenting
    private let service: MarvelServicing
    private var characters = [Character]()
    
    weak var delegate: SearchDelegate?
    
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
        case .internetFailure:
            presenter.presentNoInternetView()
        default:
            presenter.presentErrorView()
        }
    }
}

extension SearchInteractor: SearchInteracting {
    func search(with name: String?) {
        guard let searchName = name, !searchName.isEmpty else {
            return
        }
        
        presenter.presentLoader()
        
        service.search(by: searchName) { [weak self] result in
            self?.presenter.hideLoader()
            
            switch result {
            case .success(let result):
                self?.handleSuccess(result)
            case .failure(let error):
                self?.handleError(error)
            }
        }
    }
    
    func didSelectCharacter(with indexPath: IndexPath) {
        guard characters.indices.contains(indexPath.row) else {
            return
        }
        
        let character = characters[indexPath.row]
        delegate?.didSelectedCharacter(character)
    }
    
    func didDismissSearch() {
        presenter.resetView()
    }
}
