import Foundation
import UIKit

class Model {
    
    init () {
    }
    
    init (urlDirectory: URL) {
        self.urlDirectory = urlDirectory
    }
    
    var urlDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    var settings = UserDefaults.standard
    
    var items: [URL] {
        let urls = (try? FileManager.default.contentsOfDirectory(at: urlDirectory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)) ?? []
        
        if self.settings.bool(forKey: "fileOrder") { //сортирует по возрастанию
            let sortedURLs = urls.sorted { a, b in
                return a.lastPathComponent.localizedStandardCompare(b.lastPathComponent)
                == ComparisonResult.orderedAscending
            }
            return sortedURLs
        } else { //сортирует по убыванию
            let sortedURLs = urls.sorted { a, b in
                return a.lastPathComponent.localizedStandardCompare(b.lastPathComponent)
                == ComparisonResult.orderedDescending
            }
            return sortedURLs //возвращает отсортированный массив
        }
    }
    
    
    func createImage (image: UIImage, imageName: String) {
       let newImageURL = urlDirectory.appendingPathComponent("\(imageName).jpg")
       let jpgImageData = image.jpegData(compressionQuality: 1.0)
            do {
                try jpgImageData!.write(to: newImageURL)
            } catch {
                print(error)
            }
     }
    
    func createFolder (folderName: String) {
        
        let newDirectoryURL = urlDirectory.appending(path: folderName)
        try? FileManager.default.createDirectory(at: newDirectoryURL, withIntermediateDirectories: true)
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
