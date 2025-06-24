import UIKit
import Combine

class FriendPageViewController: UIViewController {
    // MARK: - Properties
    let viewModel = FriendPageViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    private let containerView = FriendContainerView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setupDismissKeyboardGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupBindings() {
        containerView.headerView.eventPublisher
            .sink { [weak self] event in
                switch event {
                case .atm:
                    AlertUtils.showAlert(on: self, title: "ATM", message: "onATMButtonTapped")
                case .transfer:
                    AlertUtils.showAlert(on: self, title: "Transfer", message: "onTransferButtonTapped")
                case .scan:
                    AlertUtils.showAlert(on: self, title: "Scan", message: "onScanButtonTapped")
                case .kokoId:
                    AlertUtils.showAlert(on: self, title: "KOKO ID", message: "onKokoIdButtonTapped")
                case .avatar:
                    AlertUtils.showAlert(on: self, title: "Avatar", message: "onAvatarButtonTapped")
                case .friendTab:
                    self?.containerView.show(tab: .friend)
                case .chatTab:
                    self?.containerView.show(tab: .chat)
                case .invitedFriendAgree(let friend):
                    self?.viewModel.acceptInvitation(for: friend)
                case .invitedFriendDecline(let friend):
                    self?.viewModel.declineInvitation(for: friend)
                }
            }
            .store(in: &cancellables)

        containerView.eventPublisher
            .sink { [weak self] event in
                switch event {
                case .friend(let friendEvent):
                    switch friendEvent {
                    case .addFriend:
                        AlertUtils.showAlert(on: self, title: "加好友", message: "onAddFriendTapped")
                    case .setKokoId:
                        AlertUtils.showAlert(on: self, title: "設定 KOKO ID", message: "onSetKokoIdLabelTapped")
                    case .transfer(let friend):
                        AlertUtils.showAlert(on: self, title: "轉帳", message: "\(friend)")
                        print("[轉帳] rawData: \(friend)")
                    case .invite(let friend):
                        AlertUtils.showAlert(on: self, title: "邀請中", message: "\(friend)")
                        print("[邀請中] rawData: \(friend)")
                    case .more(let friend):
                        AlertUtils.showAlert(on: self, title: "更多", message: "\(friend)")
                        print("[更多] rawData: \(friend)")
                    case .refresh:
                        guard let self = self else { return }
                        self.viewModel.loadData(for: self.viewModel.currentState)
                    }
                }
            }
            .store(in: &cancellables)

        viewModel.$user
            .receive(on: RunLoop.main)
            .sink { [weak self] user in
                if let user = user {
                    self?.containerView.headerView.updateUser(user)
                } else {
                    // for 無好友狀態（順便清空來展示UI)
                    self?.containerView.headerView.resetUserUI()
                }
            }
            .store(in: &cancellables)

        viewModel.$friends
            .combineLatest(viewModel.$invitations)
            .receive(on: RunLoop.main)
            .sink { [weak self] friends, invitations in
                self?.containerView.updateFriendsAndInvitations(friends: friends, invitations: invitations)
                self?.containerView.headerView.updateBadges(friends: invitations)
                self?.containerView.endFriendRefreshing()
            }
            .store(in: &cancellables)
    }

    private func setupDismissKeyboardGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

