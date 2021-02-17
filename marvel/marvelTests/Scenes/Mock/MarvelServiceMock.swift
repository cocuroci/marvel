import XCTest
@testable import marvel

final class MarvelServiceMock: MarvelServicing {
    var listResult: Result<[Character], ApiError>?
    
    func list(completion: @escaping (Result<[Character], ApiError>) -> Void) {
        guard let result = listResult else {
            XCTFail("Mocked listResult for list method is nil")
            return
        }
        
        completion(result)
    }
    
    var searchResult: Result<[Character], ApiError>?
    
    func search(by name: String, completion: @escaping (Result<[Character], ApiError>) -> Void) {
        guard let result = searchResult else {
            XCTFail("Mocked searchResult for search method is nil")
            return
        }
        
        completion(result)
    }
}
