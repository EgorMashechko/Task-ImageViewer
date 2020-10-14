
import UIKit
import Security

enum LogInUserDefaultsKey: String {
    case passwordKey
}

class LoginViewController: UIViewController {

//MARK: Properties
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var passwordTextField: UITextField!
    private var passwordManager: PasswordManager?
    
//MARK: LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustScrollView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustScrollView), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        passwordManager = PasswordManager()
        passwordTextField.delegate = self
    }
    
//MARK: Methods
    @objc private func adjustScrollView(notification: Notification) {
        guard let keyboardFrameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardFrameValue.cgRectValue
        
        switch notification.name {
        case UIResponder.keyboardWillHideNotification:
            scrollView.contentInset = .zero
        case UIResponder.keyboardWillShowNotification:
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        default: break
        }
    }

    @IBAction private func onSetPasswordLabelTap(_ sender: UITapGestureRecognizer) {
        setPassword()
    }
    
    private func setPassword() {
        let alert = UIAlertController(title: "Set a password to acces the image storage", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "type password"
        }
        let action = UIAlertAction(title: "Continue", style: .default) { (_) in
            let text = alert.textFields?[0].text
            self.passwordManager?.savePassword(text, forKey: LogInUserDefaultsKey.passwordKey.rawValue)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction private func onButtonLogIn(_ sender: UIButton) {
        userLogIn()
    }
    
    private func userLogIn() {
        guard let password = passwordManager?.password(forKey: LogInUserDefaultsKey.passwordKey.rawValue), let text = passwordTextField.text else {return}
        if password == text {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            if let destinationVC = storyboard.instantiateInitialViewController() as? ViewController {
                navigationController?.pushViewController(destinationVC, animated: true)
            }
        }
    }
    
}

// MARK: TextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userLogIn()
        textField.resignFirstResponder()
        return true
    }
}
