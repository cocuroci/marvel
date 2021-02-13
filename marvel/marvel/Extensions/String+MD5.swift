import Foundation
import CryptoKit

extension String {
    var md5: String {
        guard let dataString = data(using: .utf8) else {
            return ""
        }
        
        let hash = Insecure.MD5.hash(data: dataString)
        return hash.map { String(format: "%02hhx", $0) }.joined()
    }
}
