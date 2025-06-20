import UIKit
import Combine

class FriendListViewController: UIViewController {
    // MARK: - Properties
    private let viewModel = FriendListViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    private var containerView: UIView?
    
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
        // 載入 ContainerView xib
        if let container = Bundle.main.loadNibNamed("ContainerView", owner: self, options: nil)?.first as? UIView {
            container.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(container)
            NSLayoutConstraint.activate([
                container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                container.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                container.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
            self.containerView = container
        }
    }
    
    private func setupBindings() {
        // 暫時不用管資料綁定，等 UI 完成再補
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