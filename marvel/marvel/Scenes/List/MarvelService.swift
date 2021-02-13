import Foundation
import Moya

protocol MarvelServicing {
    func list(completion: @escaping (Result<[Character], ApiError>) -> Void)
    func search(by name: String, completion: @escaping (Result<[Character], ApiError>) -> Void)
}

final class MarvelService {
    private let provider: MoyaProvider<MarvelEndpoint>
    private let dispatchQueue: DispatchQueue
    
    init(provider: MoyaProvider<MarvelEndpoint>, dispatchQueue: DispatchQueue = DispatchQueue.main) {
        self.provider = provider
        self.dispatchQueue = dispatchQueue
    }
    
    private func parse(response: Result<Response, MoyaError>, completion: @escaping (Result<[Character], ApiError>) -> Void) {
        switch response {
        case .success(let result):
            do {
                let arrayOfCharacters = try result.filterSuccessfulStatusCodes().map(CharacterDataWrapper.self).data?.results ?? []
                dispatchQueue.async {
                    completion(.success(arrayOfCharacters))
                }
            } catch {
                let errorParsed = parseError(error)
                dispatchQueue.async {
                    completion(.failure(errorParsed))
                }
            }
        case .failure(let error):
            let errorParsed = parseError(error)
            dispatchQueue.async {
                completion(.failure(errorParsed))
            }
        }
    }
    
    private func parseError(_ error: Error) -> ApiError {
        guard let currentError = error as? MoyaError else {
            return .unknown
        }
        
        switch currentError {
        case .underlying(let nsError as NSError, _):
            return isNotConnectedToInternetError(code: nsError.code) ? .internetFailure : .generic
        default:
            return .generic
        }
    }
    
    // bug moya?
    private func isNotConnectedToInternetError(code: Int) -> Bool {
        code == URLError.notConnectedToInternet.rawValue || code == 13 ? true : false
    }
}


extension MarvelService: MarvelServicing {
    func list(completion: @escaping (Result<[Character], ApiError>) -> Void) {
        provider.request(.list) { [weak self] response in
            self?.parse(response: response, completion: completion)
        }
    }
    
    func search(by name: String, completion: @escaping (Result<[Character], ApiError>) -> Void) {
        provider.request(.search(name: name)) { [weak self] response in
            self?.parse(response: response, completion: completion)
        }
    }
}
