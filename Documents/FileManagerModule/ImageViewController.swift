
import UIKit

class ImageViewController: UIViewController {

    convenience init (image: UIImage){
        self.init()
        self.image.image = image
    }
    
    
    private lazy var image: UIImageView = {
        let image  = UIImageView ()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .black
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(image)
        setupConstraints()
        
        
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            image.centerYAnchor.constraint(equalTo: safeAreaGuide.centerYAnchor)
        ])
    }
}
