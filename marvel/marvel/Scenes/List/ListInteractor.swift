import Foundation

protocol ListInteracting {
    func fetchList()
}

final class ListInteractor {
    private let presenter: ListPresenting
    
    init(presenter: ListPresenting) {
        self.presenter = presenter
    }
}

extension ListInteractor: ListInteracting {
    func fetchList() {
        presenter.presentCharacters([
            Character(id: 123, name: "Homem-Aranha", description: nil, image: nil)
        ])
    }
}
