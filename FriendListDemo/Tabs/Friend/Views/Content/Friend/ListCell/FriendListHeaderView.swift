import UIKit

class FriendListHeaderView: UITableViewHeaderFooterView, ReusableCell {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var addFriendButton: UIButton!

    var onSearchTextChanged: ((String) -> Void)?
    var onAddFriendTapped: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupBindings()
        contentView.backgroundColor = .white
        backgroundView = UIView()
        backgroundView?.backgroundColor = .white
    }

    private func setupUI() {
        let icon = UIImageView(image: .friendSearch)
        icon.contentMode = .center
        icon.sizeToFit()
        let padding: CGFloat = 10
        let container = UIView(frame: CGRect(x: 0, y: 0, width: icon.frame.width + padding, height: icon.frame.height))
        icon.frame = CGRect(x: padding, y: 0, width: icon.frame.width, height: icon.frame.height)
        container.addSubview(icon)
        searchTextField.leftView = container
        searchTextField.leftViewMode = .always
        searchTextField.backgroundColor = .steel.withAlphaComponent(0.12)
        let placeholderColor = UIColor.steel
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: placeholderColor
        ]
        searchTextField.attributedPlaceholder = NSAttributedString(string: "想轉一筆給誰呢？", attributes: attributes)
    }

    private func setupBindings() {
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        addFriendButton.addAction(UIAction { [weak self] _ in
            self?.onAddFriendTapped?()
        }, for: .touchUpInside)
    }

    @objc private func textChanged() {
        onSearchTextChanged?(searchTextField.text ?? "")
    }
}

// MARK: - UITextFieldDelegate
extension FriendListHeaderView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
} 
