

import UIKit

class FolderController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var model = Model()
    
    var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        title = model.urlDirectory.lastPathComponent
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "+Image", style: .plain, target: self, action: #selector(addPhoto(_:))), UIBarButtonItem(title: "+Folder", style: .plain, target: self, action: #selector(addDirectory(_:)))]
        
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
    
    // MARK: - Table view data source

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var configuration = UIListContentConfiguration.cell()
        configuration.text = model.items[indexPath.row].lastPathComponent
        //вписываем в ячейку аттрибуты дата создания и размер файла
        if model.isDirectory(atindex: indexPath.row) == false {
            let attr = try? (FileManager.default.attributesOfItem(atPath: model.items[indexPath.row].path))
            let fileSize = attr?[FileAttributeKey.size] as! UInt64
            let fileDate = attr?[FileAttributeKey.modificationDate] as! Date
            let formatter = DateFormatter()
            formatter.dateFormat = "MM-dd-yyyy HH:mm"
            if model.settings.bool(forKey: "fileSize") {
                configuration.secondaryText = "file, modified \(formatter.string(from: fileDate)), size \(fileSize/1024) KB" }
            else {
                configuration.secondaryText = "file, modified \(formatter.string(from: fileDate))"
            }
        } else {//или вписываем FOLDER если папка
            configuration.secondaryText = "FOLDER"
        }
        //настраиваем превью изображений в ячейке
        configuration.image = UIImage(contentsOfFile: model.items[indexPath.row].path)
        configuration.imageProperties.maximumSize = CGSize(width: 50.0, height: 50.0)
        cell.contentConfiguration = configuration
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if model.isDirectory(atindex: indexPath.row) { //если папка то переходим в нее
            let newModel = Model(urlDirectory: model.urlDirectory.appending(path: model.items[indexPath.row].lastPathComponent))
            FolderController.push(in: self, model: newModel)
           
        } else {//если файл то открываем изображение в отд вью контроллере
            if let image = UIImage(contentsOfFile: model.items[indexPath.row].path) {
                let imageViewController = ImageViewController(image: image)
                present(imageViewController, animated: true)
            } else {
                return
            }
                       
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        model.removeItem(atIndex: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    @objc func addPhoto(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func addDirectory(_ sender: UIButton) {
        
        model.createFolder(folderName: "NewSuperFolder")
        self.tableView.reloadData()
    }

}

extension FolderController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            picker.dismiss(animated: true)
            let alert = UIAlertController(title: "Enter file name", message: nil, preferredStyle: .alert)
            alert.addTextField()
            
            let actionOK = UIAlertAction(title: "OK", style: .default, handler: {_ in
                //МОЖНО СДЕЛАТЬ ПРОВЕРКУ НА ПУСТОЕ ЗНАЧЕНИЕ
                let imageName = alert.textFields![0].text!
                self.model.createImage(image: image, imageName: imageName)
                self.tableView.reloadData()

            })
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(actionOK)
            alert.addAction(actionCancel)
            present(alert, animated: true)
            
        }
    }
}

extension FolderController {
    //функция для навигации по папкам
    static func push (in viewController: UIViewController, model: Model) {
        
        let fc = FolderController()
        fc.model = model
        viewController.navigationController?.pushViewController(fc, animated: true)
        
        
    }
    
}

