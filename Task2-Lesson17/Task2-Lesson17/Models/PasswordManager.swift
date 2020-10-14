
import Foundation
import Security

class PasswordManager {
    
//MARK: Methods
    func savePassword(_ password: String?, forKey: String?) {
        guard let password = password, let key = forKey else {return}
        var queryDict: [String: Any] = [:]
        queryDict[kSecAttrService as String] = key
        queryDict[kSecClass as String] = kSecClassGenericPassword as String
        queryDict[kSecValueData as String] = password.data(using: .utf8)
        
        let status = SecItemAdd(queryDict as CFDictionary, nil)
        
        switch status {
        case errSecDuplicateItem:
            var updDict: [String: Any] = [:]
            updDict[kSecAttrService as String] = key
            updDict[kSecClass as String] = kSecClassGenericPassword as String
            var attrDict: [String: Any] = [:]
            attrDict[kSecValueData as String] = password.data(using: .utf8)
            SecItemUpdate(updDict as CFDictionary, attrDict as CFDictionary)
        default:
            return
        }
    }
    
    func password(forKey: String?) -> String? {
        guard let key = forKey else {return nil}
        var queryDict: [String: Any] = [:]
        queryDict[kSecAttrService as String] = key
        queryDict[kSecClass as String] = kSecClassGenericPassword as String
        queryDict[kSecMatchLimit as String] = kSecMatchLimitOne as String
        queryDict[kSecReturnAttributes as String] = true
        queryDict[kSecReturnData as String] = true
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(queryDict as CFDictionary, &item)
        guard status == errSecSuccess else {return nil}
        guard let resultDict = item as? [String: Any], let data = resultDict[kSecValueData as String] as? Data else  { return nil }
        let password = String(data: data, encoding: String.Encoding.utf8)
        return password
    }
}
