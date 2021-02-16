import Foundation

protocol SearchPresenting {
    var viewController: SearchDisplaying? { get set }
    func presentCharacters(_ characters: [Character])
    func presentEmptyResultView()
    func resetView()
}

final class SearchPresenter {
    weak var viewController: SearchDisplaying?
}

extension SearchPresenter: SearchPresenting {
    func presentCharacters(_ characters: [Character]) {
        viewController?.displayCharacters(characters)
    }
    
    func presentEmptyResultView() {
        viewController?.displayEmptyView(text: "Busca não encontrada", imageName: "exclamationmark.circle")
    }
    
    func resetView() {
        viewController?.resetView()
    }
}
