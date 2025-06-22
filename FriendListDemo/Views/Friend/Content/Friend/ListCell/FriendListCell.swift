import UIKit

class FriendListCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var starImageView: UIImageView!
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
        // 其他屬性根據 model 設定
    }
} 