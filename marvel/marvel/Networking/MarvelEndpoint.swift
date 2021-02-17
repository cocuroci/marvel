import Foundation
import Moya

enum MarvelEndpoint {
    case list
    case search(name: String)
    
    private static let limitKey = "limit"
    private static let apiKey = "apikey"
    private static let timestampKey = "ts"
    private static let hashKey = "hash"
    private static let searchNameKey = "nameStartsWith"
    private static let limitResult = 100
}

extension MarvelEndpoint: TargetType {
    var baseURL: URL {
        URL(string: "https://gateway.marvel.com")!
    }
    
    var path: String {
        "/v1/public/characters"
    }
    
    var method: Moya.Method {
        .get
    }
    
    var sampleData: Data {
        Data()
    }
    
    var task: Task {
        let timestamp = "\(Date().timeIntervalSince1970)"
        let hash = "\(timestamp)\(Environment.privateKey)\(Environment.apiKey)".md5
        
        switch self {
        case .list:
            return Task.requestParameters(
                parameters: [
                    MarvelEndpoint.limitKey: MarvelEndpoint.limitResult,
                    MarvelEndpoint.apiKey: Environment.apiKey,
                    MarvelEndpoint.timestampKey: timestamp,
                    MarvelEndpoint.hashKey: hash
                ], encoding: URLEncoding.default
            )
        case .search(let name):
            return Task.requestParameters(
                parameters: [
                    MarvelEndpoint.limitKey: MarvelEndpoint.limitResult,
                    MarvelEndpoint.searchNameKey: name,
                    MarvelEndpoint.apiKey: Environment.apiKey,
                    MarvelEndpoint.timestampKey: timestamp,
                    MarvelEndpoint.hashKey: hash
                ], encoding: URLEncoding.default
            )
        }
    }
    
    var headers: [String : String]? {
        nil
    }
}
