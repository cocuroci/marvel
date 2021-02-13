import Foundation

protocol ListInteracting {
    func fetchList()
}

final class ListInteractor {
    private let presenter: ListPresenting
    private let service: MarvelServicing
    
    init(presenter: ListPresenting, service: MarvelServicing) {
        self.presenter = presenter
        self.service = service
    }
}

extension ListInteractor: ListInteracting {
    func fetchList() {
        service.list { result in
            switch result {
            case .success(let characters):
                break
            case .failure(let error):
                break
            }
        }
    }
}
