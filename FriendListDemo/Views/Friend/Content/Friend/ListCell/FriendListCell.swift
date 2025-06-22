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
        transferButton.addTarget(self, action: #selector(transferTapped), for: .touchUpInside)
        inviteButton.addTarget(self, action: #selector(inviteTapped), for: .touchUpInside)
        moreButton.addTarget(self, action: #selector(moreTapped), for: .touchUpInside)
    }

    @objc private func transferTapped() {
        onTransferTapped?()
    }

    @objc private func inviteTapped() {
        onInviteTapped?()
    }

    @objc private func moreTapped() {
        onMoreTapped?()
    }

    func configure(with friend: Friend) {
        nameLabel.text = friend.name

        if friend.status == .inviting { // 轉帳 + 邀請中
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
