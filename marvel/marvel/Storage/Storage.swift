import Foundation

protocol LocalStorageProtocol {
    func save<Object: Codable>(object: Object)
    func remove<Object: Codable & Identifiable>(object: Object)
    func getObjects<Object: Decodable>() -> [Object]
}

final class LocalStorage {
    private let userDefaults: ObjectSavable
    private let key: String
    
    init(userDefaults: ObjectSavable = UserDefaults.standard, forKey: String) {
        self.userDefaults = userDefaults
        self.key = forKey
    }
}

extension LocalStorage: LocalStorageProtocol {
    func save<Object: Codable>(object: Object) {
        var result: [Object] = getObjects()
        result.append(object)
        userDefaults.setObject(object: result, forKey: key)
    }
    
    func remove<Object: Codable & Identifiable>(object: Object) {
        let filtered: [Object] = getObjects().filter { $0.id != object.id }
        userDefaults.setObject(object: filtered, forKey: key)
    }
    
    func getObjects<Object: Decodable>() -> [Object] {
        userDefaults.getObject(forKey: key, withType: [Object].self) ?? []
    }
}
