import UIKit

class ContainerView: UIView {
    // MARK: - Properties
    @IBOutlet weak var headerView: HeaderView!
    // Content Views
    private lazy var friendView: FriendView = {
        let view = FriendView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // 將 friendView 的事件轉發給 ContainerView 的 callbacks
        view.onAddFriendTapped = { [weak self] in
            self?.onAddFriendTapped?()
        }
        view.onSetKokoIdLabelTapped = { [weak self] in
            self?.onSetKokoIdLabelTapped?()
        }
        
        return view
    }()
    
    private lazy var chatView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = "ChatView"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return view
    }()

    // MARK: - Callbacks
    var onAddFriendTapped: (() -> Void)?
    var onSetKokoIdLabelTapped: (() -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNibToSelf()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromNibToSelf()
        setupViews()
    }

    // MARK: - Private Methods
    private func setupViews() {
        addSubview(friendView)
        addSubview(chatView)
        
        NSLayoutConstraint.activate([
            friendView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            friendView.leadingAnchor.constraint(equalTo: leadingAnchor),
            friendView.trailingAnchor.constraint(equalTo: trailingAnchor),
            friendView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            chatView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            chatView.leadingAnchor.constraint(equalTo: leadingAnchor),
            chatView.trailingAnchor.constraint(equalTo: trailingAnchor),
            chatView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        show(tab: .friend)
    }
    
    // MARK: - Public Methods
    public func show(tab: HeaderView.TabType) {
        friendView.isHidden = (tab != .friend)
        chatView.isHidden = (tab != .chat)
    }
} 
