import Foundation

protocol ListPresenting {
    var viewController: ListDisplaying? { get set }
    func presentCharacters(_ characters: [Character])
    func presentLoader()
    func hideLoader()
    func presentNoInternetView()
    func presentErrorView()
    func presentEmptyResultView()
    func removeFeedbackView()
    func didNextStep(action: ListAction)
}

final class ListPresenter {
    private let coordinator: ListCoordinating
    weak var viewController: ListDisplaying?
    
    init(coordinator: ListCoordinating) {
        self.coordinator = coordinator
    }
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
    
    func presentEmptyResultView() {
        viewController?.displayEmptyView(text: "Resultado não encontrado", imageName: "exclamationmark.circle")
    }
    
    func removeFeedbackView() {
        viewController?.removeFeedbackView()
    }
    
    func didNextStep(action: ListAction) {
        coordinator.perform(action: action)
    }
}
