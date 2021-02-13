import Foundation

protocol ListPresenting {
    var viewController: ListDisplaying? { get set }
    func presentCharacters(_ characters: [Character])
    func presentLoader()
    func hideLoader()
    func presentNoInternetView()
    func presentErrorView()
    func removeFeedbackView()
}

final class ListPresenter {
    weak var viewController: ListDisplaying?
}

extension ListPresenter: ListPresenting {
    func presentCharacters(_ characters: [Character]) {
        viewController?.displayCharacters(characters)
    }
    
    func presentLoader() {
        viewController?.displayLoader()
    }
    
    func hideLoader() {
        viewController?.hideLoader()
    }
    
    func presentNoInternetView() {
        viewController?.displayFeedbackView(text: "Sem conexão", imageName: "wifi.slash")
    }
    
    func presentErrorView() {
        viewController?.displayFeedbackView(text: "Ops! Falha na requisição", imageName: "exclamationmark.circle")
    }
    
    func removeFeedbackView() {
        viewController?.removeFeedbackView()
    }
}
