import UIKit

class FriendInviteCardView: UIView {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var agreeButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!

    // 必須回傳高度，好讓 expand view 能夠展開真正的大小
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 70)
    }

    // MARK: - Callback
    var onAgreeTapped: ((Friend) -> Void)?
    var onDeclineTapped: ((Friend) -> Void)?
    private var currentInvite: Friend?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNibToSelf()
        setupBindings()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromNibToSelf()
        setupBindings()
    }

    // MARK: - Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.masksToBounds = false
        containerView.layer.cornerRadius = 6
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 16
    }

    // MARK: - Private
    private func setupBindings() {
        agreeButton.addAction(UIAction { [weak self] _ in
            guard let self = self, let invite = self.currentInvite else { return }
            self.onAgreeTapped?(invite)
        }, for: .touchUpInside)
        declineButton.addAction(UIAction { [weak self] _ in
            guard let self = self, let invite = self.currentInvite else { return }
            self.onDeclineTapped?(invite)
        }, for: .touchUpInside)
    }

    // MARK: - Public
    func configure(with invite: Friend) {
        nameLabel.text = invite.name
        currentInvite = invite
    }
} 
