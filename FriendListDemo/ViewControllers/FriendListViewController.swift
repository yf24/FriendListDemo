import UIKit
import Combine

class FriendListViewController: UIViewController {
    // MARK: - Properties
    private let viewModel = FriendListViewModel()
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
        // 串接 headerView 所有事件
        containerView.headerView.onATMButtonTapped = { [weak self] in
            print("onATMButtonTapped")
        }
        containerView.headerView.onTransferButtonTapped = { [weak self] in
            print("onTransferButtonTapped")
        }
        containerView.headerView.onScanButtonTapped = { [weak self] in
            print("onScanButtonTapped")
        }
        containerView.headerView.onKokoIdButtonTapped = { [weak self] in
            print("onKokoIdButtonTapped")
        }
        containerView.headerView.onAvatarButtonTapped = { [weak self] in
            print("onAvatarButtonTapped")
        }
        containerView.headerView.onFriendButtonTapped = { [weak self] in
            print("onFriendButtonTapped")
        }
        containerView.headerView.onChatButtonTapped = { [weak self] in
            print("onChatButtonTapped")
        }
        containerView.contentView.onAddFriendTapped = { [weak self] in
            print("onAddFriendTapped")
        }
        containerView.contentView.onSetKokoIdLabelTapped = { [weak self] in
            print("onSetKokoIdLabelTapped")
        }
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension FriendListViewController: UITableViewDelegate, UITableViewDataSource {
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
