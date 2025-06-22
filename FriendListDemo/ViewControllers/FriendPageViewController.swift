import UIKit
import Combine

class FriendPageViewController: UIViewController {
    private let viewModel = FriendPageViewModel()
    
    // MARK: - Properties
    private let containerView = ContainerView()

    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setupDismissKeyboardGesture()
        viewModel.loadData(for: .empty)
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
                    }
                }
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

// MARK: - UITableViewDelegate & UITableViewDataSource
extension FriendPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath)
        let friend = viewModel.friends[indexPath.row]
        cell.textLabel?.text = friend.name
        return cell
    }
} 
