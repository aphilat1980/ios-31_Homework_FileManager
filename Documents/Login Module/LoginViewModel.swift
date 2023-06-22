import Foundation
import UIKit

class LoginViewModel {
    
    var firstPassword: String?
    
    enum State { //состояния вью модели для передачи во вью
        case passwordIsExist //пароль существует
        case passwordIsCorrect //пароль существует и введен корректный пароль
        case passwordIsNotExist //пароль не существует
        case passwordRepeating //пароль не существует, повторный ввод пароля
        case incorrectPassword //введен неправильный пароль
    }
    
    enum ViewInput {// передаваемые данные из вью во вью модель
        case initViewControllerState //запуск вью-контроллера
        case checkPasswordButtonTapped (String) //нажата кнопка для контроля сущ пароля
        case firstTimeButtonTapped (String)
        case secondTimeButtonTapped (String)
    }
    
    //замыкание для передачи состояния модели во view
    var onStateDidChange: ((State)-> Void)?
    
    var state: State = .passwordIsNotExist {
        didSet {
            onStateDidChange?(state)
        }
    }
    
    var keychain : KeychainService
    
    init(keychain: KeychainService) {
        self.keychain = keychain
    }
    
    //метод при передаче данных из view
    
    func updateState (viewInput: ViewInput) {
        switch viewInput {
        
        case .initViewControllerState:
            state = keychain.checkPasswodExist() ? .passwordIsExist : .passwordIsNotExist
            
        case let .checkPasswordButtonTapped(password):
            state = self.keychain.checkPassword(password: password) ? .passwordIsCorrect : .incorrectPassword
        
        case let .firstTimeButtonTapped(password):
            if password.count > 3 {
                self.firstPassword = password
                state = .passwordRepeating
            } else {
                state = .incorrectPassword
            }
            
        case let .secondTimeButtonTapped(password):
            if self.firstPassword == password {
                keychain.setPassword(password: password)
                state = .passwordIsCorrect
            } else {
                state = .incorrectPassword
            }
        }
    }
}
