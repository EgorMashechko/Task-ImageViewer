

import Foundation
import UIKit

class ImageInspector {
    
    private let storagePathSuffix = "/Representations"
    private let storeDataPathSuffix = "/Representation"
    private let fileManager = FileManager.default
    private var storageURL: URL!
    
    private var representationsArray: [String]? {
        return try? fileManager.contentsOfDirectory(atPath: storageURL.path)
    }
    
    var representData: [ImageRepresentation]? {
        guard let representerNames = representationsArray else {return nil}
        var representers = [ImageRepresentation]()
        for name in representerNames {
            let representerPath = storageURL.path + "/" + name
            if let representerData = fileManager.contents(atPath: representerPath) {
                let decoder = JSONDecoder()
                if let representer = try? decoder.decode(ImageRepresentation.self, from: representerData) {
                    representers.append(representer)
                }
            }
        }
        return representers
    }
    
    func addToStorage(_ image: UIImage?) {
        
        let imageData = image?.pngData()
        let representer = ImageRepresentation(imageData: imageData)
        let encoder = JSONEncoder()
        let storeData = try? encoder.encode(representer)
        if let storageArray = representationsArray {
            let item = storageArray.count
            let storePath = storageURL.path + storeDataPathSuffix + "\(item).json"
            fileManager.createFile(atPath: storePath, contents: storeData, attributes: nil)
        }
    }
    
    func saveData(of array: [ImageRepresentation]?) {
        guard let _array = array else {return}
        let encoder = JSONEncoder()
        for (index, item) in _array.enumerated() {
            if let storeData = try? encoder.encode(item) {
                let storePath = storageURL.path + storeDataPathSuffix + "\(index).json"
                fileManager.createFile(atPath: storePath, contents: storeData, attributes: nil)
            }
        }
    }
    
    init() {
        if let directory = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            let storageDirectoryPath = directory.path + storagePathSuffix
            if fileManager.fileExists(atPath: storageDirectoryPath) == false {
                try? fileManager.createDirectory(atPath: storageDirectoryPath, withIntermediateDirectories: true, attributes: nil)
            }
            storageURL = URL(string: storageDirectoryPath)
        }
    }
}



