import UIKit
import Combine

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
    // 小紅點
    private let redDotView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(resource: .hotPink)
        view.layer.cornerRadius = 5
        view.isHidden = false // 預設顯示，未來可根據狀態控制
        return view
    }()

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
    }
    // MARK: - Publisher
    let eventPublisher = PassthroughSubject<Event, Never>()


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
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBindings()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }

    // MARK: - Binding
    private func setupUI() {
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
