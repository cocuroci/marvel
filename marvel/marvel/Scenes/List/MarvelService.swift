import Foundation
import Moya

protocol MarvelServicing {
    func list(completion: @escaping (Result<[Character], Error>) -> Void)
    func search(by name: String, completion: @escaping (Result<[Character], Error>) -> Void)
}

final class MarvelService {
    private let provider: MoyaProvider<MarvelEndpoint>
    private let dispatchQueue: DispatchQueue
    
    init(provider: MoyaProvider<MarvelEndpoint>, dispatchQueue: DispatchQueue = DispatchQueue.main) {
        self.provider = provider
        self.dispatchQueue = dispatchQueue
    }
    
    private func parse(response: Result<Response, MoyaError>, completion: @escaping (Result<[Character], Error>) -> Void) {
        switch response {
        case .success(let result):
            do {
                let arrayOfCharacters = try result.filterSuccessfulStatusCodes().map(CharacterDataContainer.self).result ?? []
                dispatchQueue.async {
                    completion(.success(arrayOfCharacters))
                }
            } catch {
                dispatchQueue.async {
                    completion(.failure(error))
                }
            }
        case .failure(let error):
            dispatchQueue.async {
                completion(.failure(error))
            }
        }
    }
}


extension MarvelService: MarvelServicing {
    func list(completion: @escaping (Result<[Character], Error>) -> Void) {
        provider.request(.list) { [weak self] response in
            self?.parse(response: response, completion: completion)
        }
    }
    
    func search(by name: String, completion: @escaping (Result<[Character], Error>) -> Void) {
        provider.request(.search(name: name)) { [weak self] response in
            self?.parse(response: response, completion: completion)
        }
    }
}
