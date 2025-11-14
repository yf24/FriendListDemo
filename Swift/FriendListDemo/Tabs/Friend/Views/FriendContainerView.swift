import UIKit
import Combine

class FriendContainerView: UIView {
    // MARK: - Properties
    @IBOutlet weak var headerView: FriendHeaderView!
    // Content Views
    private lazy var friendView: FriendView = {
        let view = FriendView()
        view.translatesAutoresizingMaskIntoConstraints = false
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

    // MARK: - Event Enum
    enum Event {
        case friend(FriendView.Event)
        // 未來可擴充 chat/header 事件
    }
    // MARK: - Publisher
    let eventPublisher = PassthroughSubject<Event, Never>()
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Data
    private var friends: [Friend] = []

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNibToSelf()
        setupViews()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

    private func setupBindings() {
        friendView.eventPublisher
            .sink { [weak self] event in
                self?.eventPublisher.send(.friend(event))
            }
            .store(in: &cancellables)
    }

    // MARK: - Public Methods
    public func show(tab: FriendHeaderView.TabType) {
        friendView.isHidden = (tab != .friend)
        chatView.isHidden = (tab != .chat)
    }

    public func updateFriendsAndInvitations(friends: [Friend], invitations: [Friend]) {
        if friends.isEmpty {
            friendView.showEmptyState()
        } else {
            friendView.hideEmptyState()
            friendView.update(with: friends)
        }
        headerView.updateInvitations(invitations)
    }

    public func endFriendRefreshing() {
        friendView.endRefreshing()
    }
} 
