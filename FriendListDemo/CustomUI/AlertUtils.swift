import UIKit

// MARK: - Alert Utils
class AlertUtils {
    static func showAlert(on vc: UIViewController?, title: String, message: String) {
        guard let vc = vc else { return }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
} 