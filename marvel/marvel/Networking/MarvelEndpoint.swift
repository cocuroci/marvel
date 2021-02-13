import Foundation
import Moya

enum MarvelEndpoint {
    case list
    case search(name: String)
}

extension MarvelEndpoint: TargetType {
    var baseURL: URL {
        URL(string: "https://gateway.marvel.com:443")!
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
        switch self {
        case .list:
            return Task.requestParameters(parameters: ["limit": 50, "apikey": Environment.apiKey], encoding: URLEncoding.default)
        case .search(let name):
            return Task.requestParameters(
                parameters: ["nameStartsWith": name, "apikey": Environment.apiKey], encoding: URLEncoding.default
            )
        }
    }
    
    var headers: [String : String]? {
        nil
    }
}
