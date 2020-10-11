

import UIKit

protocol ImageCollectionViewCellDelegate: AnyObject {
    func cellTextFieldDidEndEditing (_ textField: UITextField)
}

class ImageCollectionViewCell: UICollectionViewCell {

//MARK: Properties
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    weak var delegate: ImageCollectionViewCellDelegate?
    
//MARK: LifeCycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustScrollView(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustScrollView(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
//MARK: Methods
    @objc private func adjustScrollView(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardValue.cgRectValue
        
        switch notification.name {
        case UIResponder.keyboardWillShowNotification:
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        case UIResponder.keyboardWillHideNotification:
            scrollView.contentInset = .zero
        default: break
        }
    }
}

//MARK: UITextFieldDelegate
extension ImageCollectionViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.cellTextFieldDidEndEditing(textField)
    }
}
