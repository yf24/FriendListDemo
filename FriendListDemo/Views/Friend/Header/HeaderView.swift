import UIKit

class HeaderView: UIView {
    // MARK: - Properties
    // nav button
    @IBOutlet weak var atmButton: UIButton!
    @IBOutlet weak var transferButton: UIButton!
    @IBOutlet weak var scanButton: UIButton!
    // user info
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var kokoIdButton: UIButton!
    @IBOutlet weak var avatarButton: UIButton!
    // control panel
    @IBOutlet weak var friendButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!

    // MARK: - Callback Closures
    var onATMButtonTapped: (() -> Void)?
    var onTransferButtonTapped: (() -> Void)?
    var onScanButtonTapped: (() -> Void)?
    var onAvatarButtonTapped: (() -> Void)?
    var onFriendButtonTapped: (() -> Void)?
    var onChatButtonTapped: (() -> Void)?
    var onKokoIdButtonTapped: (() -> Void)?

    // MARK: - Type Control
    enum TabType { case friend, chat }
    private(set) var selectedTab: TabType = .friend

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNibToSelf()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromNibToSelf()
    }
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupBindings()
    }

    // MARK: - Binding
    private func setupUI() {
        kokoIdButton.setRightImageStyle(
            font: .systemFont(ofSize: 13, weight: .regular),
            title: "設定 KOKO ID".localized,
            image: UIImage(resource: .kokoIdArrow),
            imagePadding: 0
        )

        updateTabSelection(.friend)
    }
    private func setupBindings() {
        atmButton.addAction(UIAction { [weak self] _ in self?.onATMButtonTapped?() }, for: .touchUpInside)
        transferButton.addAction(UIAction { [weak self] _ in self?.onTransferButtonTapped?() }, for: .touchUpInside)
        scanButton.addAction(UIAction { [weak self] _ in self?.onScanButtonTapped?() }, for: .touchUpInside)
        kokoIdButton.addAction(UIAction { [weak self] _ in self?.onKokoIdButtonTapped?() }, for: .touchUpInside)
        avatarButton.addAction(UIAction { [weak self] _ in self?.onAvatarButtonTapped?() }, for: .touchUpInside)
        
        friendButton.addAction(UIAction { [weak self] _ in
            self?.updateTabSelection(.friend)
            self?.onFriendButtonTapped?()
        }, for: .touchUpInside)
        
        chatButton.addAction(UIAction { [weak self] _ in
            self?.updateTabSelection(.chat)
            self?.onChatButtonTapped?()
        }, for: .touchUpInside)
    }
}

// MARK: - Public API
extension HeaderView {
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
}
