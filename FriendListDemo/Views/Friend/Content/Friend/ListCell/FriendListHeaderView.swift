import UIKit

class FriendListHeaderView: UIView {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var addFriendButton: UIButton!

    var onSearchTextChanged: ((String) -> Void)?
    var onAddFriendTapped: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        searchTextField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        addFriendButton.addAction(UIAction { [weak self] _ in
            self?.onAddFriendTapped?()
        }, for: .touchUpInside)
    }

    @objc private func textChanged() {
        onSearchTextChanged?(searchTextField.text ?? "")
    }
} 