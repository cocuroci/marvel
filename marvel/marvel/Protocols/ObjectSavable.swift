import Foundation

protocol ObjectSavable {
    func setObject<Object: Encodable>(object: Object, forKey: String)
    func getObject<Object: Decodable>(forKey: String, withType: Object.Type) -> Object?
}

extension UserDefaults: ObjectSavable {
    func setObject<Object>(object: Object, forKey: String) where Object : Encodable {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(object) else {
            return
        }
        
        set(data, forKey: forKey)
    }
    
    func getObject<Object>(forKey: String, withType: Object.Type) -> Object? where Object : Decodable {
        let decoder = JSONDecoder()
        guard let data = data(forKey: forKey) else {
            return nil
        }

        return try? decoder.decode(withType, from: data)
    }
}
