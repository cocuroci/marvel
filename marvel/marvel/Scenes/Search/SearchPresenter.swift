import Foundation

protocol SearchPresenting {
    var viewController: SearchDisplaying? { get set }
    func presentCharacters(_ characters: [Character])
    func presentLoader()
    func hideLoader()
    func presentEmptyResultView()
    func presentNoInternetView()
    func presentErrorView()
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
    
    func presentLoader() {
        viewController?.displayLoader()
    }
    
    func presentNoInternetView() {
        viewController?.displayFeedbackView(text: "Sem conexão", imageName: "wifi.slash", hideActionButton: true)
    }
    
    func presentErrorView() {
        viewController?.displayFeedbackView(
            text: "Ops! Falha na requisição",
            imageName: "exclamationmark.circle",
            hideActionButton: true
        )
    }
    
    func hideLoader() {
        viewController?.hideLoader()
    }
}
