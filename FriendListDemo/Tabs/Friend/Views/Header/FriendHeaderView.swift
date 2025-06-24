import UIKit
import Combine

class FriendHeaderView: UIView {
    // MARK: - Properties
    // nav button
    @IBOutlet weak var atmButton: UIButton!
    @IBOutlet weak var transferButton: UIButton!
    @IBOutlet weak var scanButton: UIButton!
    // 管理 user info, invite area, conrol panel
    @IBOutlet weak var topStackView: UIStackView!
    // user info
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var kokoIdButton: UIButton!
    @IBOutlet weak var avatarButton: UIButton!
    // invite area
    @IBOutlet weak var inviteCardExpandView: FriendInviteCardExpandView!
    // control panel
    @IBOutlet weak var friendButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    // 小紅點
    private let redDotView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(resource: .hotPink)
        view.layer.cornerRadius = 5
        view.isHidden = false // 預設顯示，未來可根據狀態控制
        return view
    }()
    // tab badge
    private let friendBadge = BadgeView(bgColor: .veryLightPink, textColor: .whiteThree)
    private let chatBadge = BadgeView(bgColor: .veryLightPink, textColor: .whiteThree)

    // MARK: - Type Control
    enum TabType { case friend, chat }
    private(set) var selectedTab: TabType = .friend

    // MARK: - Event Enum
    enum Event {
        case atm
        case transfer
        case scan
        case avatar
        case friendTab
        case chatTab
        case kokoId
        case invitedFriendAgree(Friend)
        case invitedFriendDecline(Friend)
    }
    // MARK: - Publisher
    let eventPublisher = PassthroughSubject<Event, Never>()


    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNibToSelf()
        setupBindings()
        setupUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromNibToSelf()
        setupBindings()
        setupUI()
    }
    
    // MARK: - Binding
    private func setupUI() {
        inviteCardExpandView.backgroundColor = .systemBackground
        kokoIdButton.setRightImageStyle(
            font: .systemFont(ofSize: 13, weight: .regular),
            title: "設定 KOKO ID".localized,
            image: UIImage(resource: .kokoIdArrow),
            imagePadding: 0
        )
        // 加小紅點
        addSubview(redDotView)
        NSLayoutConstraint.activate([
            redDotView.widthAnchor.constraint(equalToConstant: 10),
            redDotView.heightAnchor.constraint(equalToConstant: 10),
            redDotView.centerYAnchor.constraint(equalTo: kokoIdButton.centerYAnchor),
            redDotView.leadingAnchor.constraint(equalTo: kokoIdButton.trailingAnchor, constant: 15)
        ])

        // add badge
        addSubview(friendBadge)
        addSubview(chatBadge)
        friendBadge.translatesAutoresizingMaskIntoConstraints = false
        chatBadge.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            friendBadge.heightAnchor.constraint(equalToConstant: 18),
            friendBadge.centerYAnchor.constraint(equalTo: friendButton.topAnchor, constant: 6),
            friendBadge.leadingAnchor.constraint(equalTo: friendButton.trailingAnchor, constant: -9.5),
            chatBadge.heightAnchor.constraint(equalToConstant: 18),
            chatBadge.centerYAnchor.constraint(equalTo: chatButton.topAnchor, constant: 6),
            chatBadge.leadingAnchor.constraint(equalTo: chatButton.trailingAnchor, constant: -9.5)
        ])
        friendBadge.isHidden = true
        chatBadge.isHidden = true

        updateTabSelection(.friend)
    }
    private func setupBindings() {
        atmButton.addAction(UIAction { [weak self] _ in
            self?.eventPublisher.send(.atm)
        }, for: .touchUpInside)
        transferButton.addAction(UIAction { [weak self] _ in
            self?.eventPublisher.send(.transfer)
        }, for: .touchUpInside)
        scanButton.addAction(UIAction { [weak self] _ in
            self?.eventPublisher.send(.scan)
        }, for: .touchUpInside)
        avatarButton.addAction(UIAction { [weak self] _ in
            self?.eventPublisher.send(.avatar)
        }, for: .touchUpInside)
        kokoIdButton.addAction(UIAction { [weak self] _ in
            self?.eventPublisher.send(.kokoId)
        }, for: .touchUpInside)
        friendButton.addAction(UIAction { [weak self] _ in
            self?.eventPublisher.send(.friendTab)
            self?.updateTabSelection(.friend)
        }, for: .touchUpInside)
        chatButton.addAction(UIAction { [weak self] _ in
            self?.eventPublisher.send(.chatTab)
            self?.updateTabSelection(.chat)
        }, for: .touchUpInside)
        inviteCardExpandView.onAgreeTapped = { [weak self] friend in
            self?.eventPublisher.send(.invitedFriendAgree(friend))
        }
        inviteCardExpandView.onDeclineTapped = { [weak self] friend in
            self?.eventPublisher.send(.invitedFriendDecline(friend))
        }
    }
}

// MARK: - Public API
extension FriendHeaderView {
    func updateTabSelection(_ tab: TabType) {
        selectedTab = tab
        // 先移除所有 indicator
        [friendButton, chatButton].forEach { $0?.removeIndicator() }
        // 切換 indicator 和字型
        let selectedButton: UIButton = tab == .friend ? friendButton : chatButton
        let unselectedButton: UIButton = tab == .friend ? chatButton : friendButton
        
        selectedButton.showIndicator(color: .hotPink)
        selectedButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
        unselectedButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .regular)
    }

    func updateInvitations(_ invitations: [Friend]) {
        inviteCardExpandView.updateInvitations(invitations)
        let spacing: CGFloat = invitations.isEmpty ? 0 : 15
        topStackView.setCustomSpacing(spacing, after: inviteCardExpandView)
        inviteCardExpandView.isHidden = invitations.isEmpty
    }

    func updateBadges(friends: [Friend]) {
        let count = friends.filter { $0.status == .inviting }.count
        if count > 0 {
            friendBadge.text = "\(count)"
            friendBadge.isHidden = false

            // 聊天 badge: 固定 99+
            chatBadge.text = "99+"
            chatBadge.isHidden = false
        } else {
            friendBadge.isHidden = true
            chatBadge.isHidden = true
        }
    }

    func updateUser(_ user: User) {
        nameLabel.text = user.name
        let hasKokoId = (user.kokoid?.isEmpty == false)
        let kokoIdTitle = hasKokoId ? "KOKO ID：\(user.kokoid!)" : "設定 KOKO ID".localized
        kokoIdButton.setRightImageStyle(
            font: .systemFont(ofSize: 13, weight: .regular),
            title: kokoIdTitle,
            image: UIImage(resource: .kokoIdArrow),
            imagePadding: 0
        )
        redDotView.isHidden = hasKokoId
    }

    // for 無好友初始狀態
    func resetUserUI() {
        nameLabel.text = "紫晽"
        kokoIdButton.setRightImageStyle(
            font: .systemFont(ofSize: 13, weight: .regular),
            title: "設定 KOKO ID".localized,
            image: UIImage(resource: .kokoIdArrow),
            imagePadding: 0
        )
        redDotView.isHidden = false
    }
}
