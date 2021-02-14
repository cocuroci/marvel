import Foundation

struct CharacterImage: Codable {
    let path: String?
    let `extension`: String?
    
    var url: URL? {
        guard
            let currentPath = path,
            let currentExtension = `extension`,
            let url = URL(string: "\(currentPath).\(currentExtension)")
            else {
                return nil
        }
        
        return url
    }
}
