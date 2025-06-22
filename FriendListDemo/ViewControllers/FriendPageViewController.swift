import UIKit
import Combine

class FriendPageViewController: UIViewController {
    // MARK: - Properties
    private let viewModel = FriendPageViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    private let containerView = ContainerView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
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
        containerView.headerView.onATMButtonTapped = { [weak self] in
            AlertUtils.showAlert(on: self, title: "ATM", message: "onATMButtonTapped")
        }
        containerView.headerView.onTransferButtonTapped = { [weak self] in
            AlertUtils.showAlert(on: self, title: "Transfer", message: "onTransferButtonTapped")
        }
        containerView.headerView.onScanButtonTapped = { [weak self] in
            AlertUtils.showAlert(on: self, title: "Scan", message: "onScanButtonTapped")
        }
        containerView.headerView.onKokoIdButtonTapped = { [weak self] in
            AlertUtils.showAlert(on: self, title: "KOKO ID", message: "onKokoIdButtonTapped")
        }
        containerView.headerView.onAvatarButtonTapped = { [weak self] in
            AlertUtils.showAlert(on: self, title: "Avatar", message: "onAvatarButtonTapped")
        }
        containerView.headerView.onFriendButtonTapped = { [weak self] in
            self?.containerView.show(tab: .friend)
        }
        containerView.headerView.onChatButtonTapped = { [weak self] in
            self?.containerView.show(tab: .chat)
        }
        containerView.onAddFriendTapped = { [weak self] in
            AlertUtils.showAlert(on: self, title: "加好友", message: "onAddFriendTapped")
        }
        containerView.onSetKokoIdLabelTapped = { [weak self] in
            AlertUtils.showAlert(on: self, title: "設定 KOKO ID", message: "onSetKokoIdLabelTapped")
        }
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
