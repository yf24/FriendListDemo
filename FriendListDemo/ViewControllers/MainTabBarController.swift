import UIKit

class MainTabBarController: UITabBarController {
    // for 展示用
    private let friendListVC = FriendPageViewController()
    private var logTextView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // for 展示用
        NotificationCenter.default.addObserver(self, selector: #selector(updateLogTextView), name: Logger.logDidUpdateNotification, object: nil)
        setupViewControllers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupViewControllers() {
        // for 展示，預載 call empty
        friendListVC.viewModel.loadData(for: .empty)

        // 錢錢 (for 展示)
        let moneyVC = UIViewController()
        moneyVC.view.backgroundColor = .white
        moneyVC.tabBarItem = UITabBarItem(title: "錢錢", image: UIImage(systemName: "dollarsign.circle"), tag: 0)
        // Log TextView
        let logTextView = UITextView()
        logTextView.translatesAutoresizingMaskIntoConstraints = false
        logTextView.isEditable = false
        logTextView.font = .systemFont(ofSize: 12)
        logTextView.backgroundColor = UIColor(white: 0.97, alpha: 1)
        logTextView.text = Logger.getLogBuffer().suffix(10).joined(separator: "\n")
        moneyVC.view.addSubview(logTextView)
        self.logTextView = logTextView
        // Segmented Control for scenario selection，放在畫面下方
        let segment = UISegmentedControl(items: ["無好友", "只有好友", "好友含邀請"])
        segment.selectedSegmentIndex = 0
        segment.translatesAutoresizingMaskIntoConstraints = false
        moneyVC.view.addSubview(segment)
        NSLayoutConstraint.activate([
            logTextView.topAnchor.constraint(equalTo: moneyVC.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            logTextView.leadingAnchor.constraint(equalTo: moneyVC.view.leadingAnchor, constant: 16),
            logTextView.trailingAnchor.constraint(equalTo: moneyVC.view.trailingAnchor, constant: -16),
            logTextView.bottomAnchor.constraint(equalTo: segment.topAnchor, constant: -16),
            segment.bottomAnchor.constraint(equalTo: moneyVC.view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            segment.centerXAnchor.constraint(equalTo: moneyVC.view.centerXAnchor),
            segment.widthAnchor.constraint(equalToConstant: 300),
            segment.heightAnchor.constraint(equalToConstant: 36)
        ])
        segment.addTarget(self, action: #selector(scenarioChanged(_:)), for: .valueChanged)
        
        // 朋友
        friendListVC.tabBarItem = UITabBarItem(title: "朋友", image: UIImage(systemName: "person.2"), tag: 1)
        
        // KO
        let koVC = UIViewController()
        koVC.view.backgroundColor = .white
        koVC.tabBarItem = UITabBarItem(title: "KO", image: UIImage(systemName: "bolt.circle"), tag: 2)
        
        // 記帳
        let accountingVC = UIViewController()
        accountingVC.view.backgroundColor = .white
        accountingVC.tabBarItem = UITabBarItem(title: "記帳", image: UIImage(systemName: "book"), tag: 3)
        
        // 設定
        let settingsVC = UIViewController()
        settingsVC.view.backgroundColor = .white
        settingsVC.tabBarItem = UITabBarItem(title: "設定", image: UIImage(systemName: "gearshape"), tag: 4)
        
        viewControllers = [
            UINavigationController(rootViewController: moneyVC),
            UINavigationController(rootViewController: friendListVC),
            UINavigationController(rootViewController: koVC),
            UINavigationController(rootViewController: accountingVC),
            UINavigationController(rootViewController: settingsVC)
        ]    
    }

    // for 展示
    @objc private func scenarioChanged(_ sender: UISegmentedControl) {
        Logger.clearLogBuffer()
        switch sender.selectedSegmentIndex {
        case 0:
            friendListVC.viewModel.loadData(for: .empty)
        case 1:
            friendListVC.viewModel.loadData(for: .friendsOnly)
        case 2:
            friendListVC.viewModel.loadData(for: .friendsWithInvitations)
        default:
            break
        }
        updateLogTextView()
    }

    @objc private func updateLogTextView() {
        DispatchQueue.main.async { [weak self] in
            self?.logTextView?.text = Logger.getLogBuffer().suffix(10).joined(separator: "\n")
        }
    }
} 
