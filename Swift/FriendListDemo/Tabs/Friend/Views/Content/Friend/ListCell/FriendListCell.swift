import UIKit

class FriendListCell: UITableViewCell, ReusableCell {
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var functionStackView: UIStackView!
    @IBOutlet weak var transferButton: UIButton!
    @IBOutlet weak var inviteButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!

    var onTransferTapped: (() -> Void)?
    var onInviteTapped: (() -> Void)?
    var onMoreTapped: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        transferButton.addAction(UIAction { [weak self] _ in
            self?.onTransferTapped?()
        }, for: .touchUpInside)
        inviteButton.addAction(UIAction { [weak self] _ in
            self?.onInviteTapped?()
        }, for: .touchUpInside)
        moreButton.addAction(UIAction { [weak self] _ in
            self?.onMoreTapped?()
        }, for: .touchUpInside)
    }

    func configure(with friend: Friend) {
        nameLabel.text = friend.name

        if friend.status == .invitedSent { // 轉帳 + 邀請送出
            inviteButton.isHidden = false
            moreButton.isHidden = true
            functionStackView.setCustomSpacing(10, after: transferButton)
        } else { // 轉帳 + more
            inviteButton.isHidden = true
            moreButton.isHidden = false
            functionStackView.setCustomSpacing(15, after: transferButton)
        }

        starImageView.isHidden = !friend.isTop
    }
} 
