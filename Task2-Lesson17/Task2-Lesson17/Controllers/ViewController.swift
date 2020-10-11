

import UIKit

class ViewController: UIViewController {
    
//MARK: Properties
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var showImagesButton: UIButton!
    private var imageInspector: ImageInspector?
    
//MARK: LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureButtonDisplay(for: addImageButton)
        configureButtonDisplay(for: showImagesButton)
        
        imageInspector = ImageInspector()
    }
    
//MARK: Methods
    private func configureButtonDisplay(for button: UIButton) {
        button.layer.cornerRadius = button.bounds.height / 2
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        let fontSize = button.bounds.height
        button.titleLabel?.font = UIFont(name: "Coralwaves-Regular", size: fontSize)
    }

    @IBAction func onAddImageButton(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func onShowImagesButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Presenter", bundle: Bundle.main)
        if let destinationVC = storyboard.instantiateInitialViewController() as? Presenter {
            destinationVC.representations = imageInspector?.representData
            navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
}

// MARK: ImagePickerControllerDelegate
extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        imageInspector?.addToStorage(image)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


