

import UIKit

class Presenter: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    private var currentRepresentation: ImageRepresentation?
    private let imageCellID = "cell"
    private let imageCellSpacing: CGFloat = 20
    var representations: [ImageRepresentation]?
    private var imageInspector: ImageInspector?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageInspector = ImageInspector()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing = imageCellSpacing
        collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: imageCellID)
    }
    
    @IBAction func onBackButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "", message: "Save before exit?", preferredStyle: .alert)
        let actionFirst = UIAlertAction(title: "Save", style: .default) { (_) in
            self.imageInspector?.saveData(of: self.representations)
            self.navigationController?.popViewController(animated: true)
        }
        let actionSecond = UIAlertAction(title: "Don't save", style: .destructive) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(actionFirst)
        alert.addAction(actionSecond)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: CollectionViewDelegate/DataSource
extension Presenter: /*UICollectionViewDelegate*/ UICollectionViewDelegateFlowLayout & UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let array = representations {
            return array.isEmpty ? 1 : array.count
        } else {return 1}
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellID, for: indexPath)
        guard let representCell = cell as? ImageCollectionViewCell, representations?.isEmpty == false else {
            return cell
        }
        let representation = representations?[indexPath.item]
        if let imageData = representation?.imageData {
            let image = UIImage(data: imageData)
            representCell.imageView.image = image
            representCell.textField.text = representation?.comment
            representCell.delegate = self
        }
        return representCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - imageCellSpacing
        let height = collectionView.bounds.height
        let size = CGSize(width: width, height: height)
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: imageCellSpacing / 2, bottom: 0, right: imageCellSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        currentRepresentation = representations?[indexPath.item]
    }
}

// MARK: ImageCollectionViewCellDelegate
extension Presenter: ImageCollectionViewCellDelegate {
    func cellTextFieldDidEndEditing(_ textField: UITextField) {
        currentRepresentation?.comment = textField.text
    }
}
