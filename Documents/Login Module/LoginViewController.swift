
import UIKit

class LoginViewController: UIViewController {
    
    let loginViewModel: LoginViewModel
    
    init(loginViewModel: LoginViewModel) {
        self.loginViewModel = loginViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public lazy var textField: UITextField = {
        let textField = UITextField ()
        textField.backgroundColor = .systemGray6
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Введите пароль не менее 4 символов..."
        return textField
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton ()
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(didTapButton), for:.touchUpInside)
        return button
    }()
    
    private lazy var buttonDel: UIButton = {
        let button = UIButton ()
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(didTapDelButton), for:.touchUpInside)
        button.setTitle("Удалить пароль", for: .normal)
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        loginViewModel.updateState(viewInput: .initViewControllerState)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray4
        view.addSubview(textField)
        view.addSubview(button)
        view.addSubview(buttonDel)
        setupConstraints()
        bindViewModel()
    }
    
    func bindViewModel () {
            
        loginViewModel.onStateDidChange = {[weak self] state in
            guard let self = self else {
                return
            }
            switch state {
                
            case .passwordIsNotExist:
                self.textField.text = ""
                self.button.setTitle("Cоздать пароль", for: .normal)
                
            case .passwordIsExist:
                self.textField.text = ""
                self.button.setTitle("Введите пароль", for: .normal)
                
            case .passwordRepeating:
                self.textField.text = ""
                self.button.setTitle("Повторите пароль", for: .normal)
                
            case .passwordIsCorrect:
        
                let folderViewController = FolderController()
                folderViewController.model.settings.set(true, forKey: "fileOrder")
                folderViewController.model.settings.set(true, forKey: "fileSize")
                let settingsViewController = SettingsViewController()
                let tabBarController = UITabBarController()
                tabBarController.tabBar.backgroundColor = .systemGray4
                tabBarController.viewControllers = [UINavigationController(rootViewController: folderViewController), UINavigationController(rootViewController: settingsViewController)]
                
                folderViewController.tabBarItem = UITabBarItem(title: "FileManager", image: UIImage(systemName: "folder.fill"), tag: 0)
                settingsViewController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape.fill"), tag: 1)
                
                tabBarController.modalPresentationStyle = .fullScreen
                self.present(tabBarController, animated: true)
                
                
            case .incorrectPassword:
                let alert = UIAlertController (title: "Ошибка", message: "Введен некорректный пароль", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel) {_ in
                    self.loginViewModel.updateState(viewInput: .initViewControllerState)
                }
                alert.addAction(action)
                self.present(alert, animated: true)
            }
        }
    }
    
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 50),
            textField.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -50),
            textField.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 200),
            textField.heightAnchor.constraint(equalToConstant: 40),
            button.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 50),
            button.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -50),
            button.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            button.heightAnchor.constraint(equalToConstant: 50),
            buttonDel.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 50),
            buttonDel.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -50),
            buttonDel.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 20),
            buttonDel.heightAnchor.constraint(equalToConstant: 50),
            
        ])
    }
    
    
    @objc private func didTapButton() {
        
        switch self.loginViewModel.state {
            
        case .passwordIsNotExist:
            self.loginViewModel.updateState(viewInput: .firstTimeButtonTapped(self.textField.text!))
            
        case .passwordRepeating:
            self.loginViewModel.updateState(viewInput: .secondTimeButtonTapped(self.textField.text!))
            
        case .passwordIsExist:
            self.loginViewModel.updateState(viewInput: .checkPasswordButtonTapped(self.textField.text!))
            
        case .passwordIsCorrect: return
        case .incorrectPassword: return
            
        }
    }
    
    @objc private func didTapDelButton() {
        
        self.loginViewModel.keychain.deletePassword()
        self.loginViewModel.updateState(viewInput: .initViewControllerState)
        
    }
}
