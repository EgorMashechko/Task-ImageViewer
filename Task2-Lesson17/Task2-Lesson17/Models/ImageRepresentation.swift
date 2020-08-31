
import UIKit

class ImageRepresentation: Codable {
    let imageData: Data?
    var comment: String? = nil
    
    init (imageData: Data?) {
        self.imageData = imageData
    }
}
