

import Foundation


class KeychainService {
    
  let keychain = KeychainSwift()
    
    func checkPasswodExist () -> Bool {
        let isExist = self.keychain.get("password") != nil ? true : false
        return isExist
        
    }
    
    func setPassword (password: String) -> Void {
        self.keychain.set (password, forKey: "password")
    }
    
    func deletePassword () -> Void {
        self.keychain.delete("password")
    }
    
    func checkPassword (password: String) -> Bool {
        password == self.keychain.get("password") ? true : false
    }

}
