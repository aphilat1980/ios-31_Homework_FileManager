
import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        view.backgroundColor = .systemGray4
        view.addSubview(tableView)
        setupConstraints()
    }
    
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor)
        ])
    }
    
    @objc private func switchOrder(_ sender:UISwitch) {
        
        if (sender.isOn == true) {
            UserDefaults.standard.set(true, forKey: "fileOrder")
        } else {
            UserDefaults.standard.set(false, forKey: "fileOrder")
        }
    }
    
    @objc private func switchFileSize (_ sender:UISwitch) {
        
        if (sender.isOn == true) {
            UserDefaults.standard.set(true, forKey: "fileSize")
        } else {
            UserDefaults.standard.set(false, forKey: "fileSize")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "Отображение по алфавиту"
            let orderSwitch = UISwitch ()
            orderSwitch.frame = .zero
            orderSwitch.setOn(true, animated: true)
            orderSwitch.addTarget(self, action: #selector(switchOrder(_: )), for: .valueChanged)
            cell.accessoryView = orderSwitch
            return cell
        
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "Отображение размера файлов"
            let fileSizeSwitch = UISwitch ()
            fileSizeSwitch.frame = .zero
            fileSizeSwitch.setOn(true, animated: true)
            fileSizeSwitch.addTarget(self, action: #selector(switchFileSize(_:)), for: .valueChanged)
            cell.accessoryView = fileSizeSwitch
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "Изменить пароль"
            return cell
        
        default: break
        
        }
     return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 1
        case 2: return 1
        default: break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            let loginViewModel = LoginViewModel(keychain: KeychainService())
            let viewController = LoginViewController(loginViewModel: loginViewModel)
            loginViewModel.keychain.deletePassword()
            present(viewController, animated: true)
        }
    }
}
