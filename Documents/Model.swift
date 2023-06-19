import Foundation
import UIKit

class Model {
    
    var urlDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    var items: [URL] {
        return (try? FileManager.default.contentsOfDirectory(at: urlDirectory, includingPropertiesForKeys: nil)) ?? []
    }
    
    func createImage (image: UIImage) {
       let newImageURL = urlDirectory.appendingPathComponent("image.jpg")
       let jpgImageData = image.jpegData(compressionQuality: 1.0)
            do {
                try jpgImageData!.write(to: newImageURL)
            } catch {
                print(error)
            }
     }
    
    
    func isDirectory (atindex index: Int) -> Bool {
        
        var isDirectory: ObjCBool = true
        FileManager.default.fileExists(atPath: items[index].path, isDirectory: &isDirectory)
        if isDirectory.boolValue {
            return true
        } else {
            return false
        }
    }
    
    func removeItem (atIndex index: Int) {
        try? FileManager.default.removeItem(at: items[index])
    }
}
