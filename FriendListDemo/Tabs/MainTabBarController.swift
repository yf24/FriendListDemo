import UIKit

class MainTabBarController: UITabBarController {
    // for 展示用
    private let friendListVC = FriendPageViewController()
    private var logTextView: UITextView?

    private let koButton = UIButton()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // for 展示用
        NotificationCenter.default.addObserver(self, selector: #selector(updateLogTextView), name: Logger.logDidUpdateNotification, object: nil)
        setupViewControllers()
        setupTabBarDivider()
        setupKOButton()
    }
    
    private func setupViewControllers() {
        // for 展示，預載 call empty
        friendListVC.viewModel.loadData(for: .empty)

        // 錢錢 (for 展示)
        let moneyVC = UIViewController()
        moneyVC.title = "錢錢".localized
        moneyVC.view.backgroundColor = .white
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

        segment.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            Logger.clearLogBuffer()
            switch segment.selectedSegmentIndex {
            case 0:
                friendListVC.viewModel.loadData(for: .empty)
            case 1:
                friendListVC.viewModel.loadData(for: .friendsOnly)
            case 2:
                friendListVC.viewModel.loadData(for: .friendsWithInvitations)
            default:
                break
            }
            self.updateLogTextView()
        }, for: .valueChanged)
        moneyVC.tabBarItem = UITabBarItem(title: "錢錢", image: .tabMoney, selectedImage: .tabMoney)
        
        // 朋友
        friendListVC.tabBarItem = UITabBarItem(title: "朋友", image: .tabFriend, selectedImage: .tabFriend)

        // KO（中間大圖，維持原本合成圖寫法）
        let koVC = UIViewController()
        koVC.title = "KO".localized
        koVC.view.backgroundColor = .white
        let koImageView = UIImage(systemName: "bolt.circle")
        koVC.tabBarItem = UITabBarItem(title: "KO", image: koImageView, tag: 2)

        // 記帳
        let accountingVC = UIViewController()
        accountingVC.title = "記帳".localized
        accountingVC.view.backgroundColor = .white
        accountingVC.tabBarItem = UITabBarItem(title: "記帳", image: .tabBookkeeping, selectedImage: .tabBookkeeping)

        // 設定
        let settingsVC = UIViewController()
        settingsVC.title = "設定".localized
        settingsVC.view.backgroundColor = .white
        settingsVC.tabBarItem = UITabBarItem(title: "設定", image: .tabSettings, selectedImage: .tabSettings)

        viewControllers = [
            UINavigationController(rootViewController: moneyVC),
            UINavigationController(rootViewController: friendListVC),
            UINavigationController(rootViewController: koVC),
            UINavigationController(rootViewController: accountingVC),
            UINavigationController(rootViewController: settingsVC)
        ]

        // 設定 tab bar tintColor
        tabBar.tintColor = UIColor(resource: .hotPink)
        tabBar.unselectedItemTintColor = UIColor(resource: .lightGrey)
    }

    private func setupTabBarDivider() {
        let divider = UIView()
        divider.backgroundColor = .veryLightPink1
        divider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(divider)
        NSLayoutConstraint.activate([
            divider.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            divider.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: -3),
            divider.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    private func setupKOButton() {
        koButton.setImage(.tabKO, for: .normal)
        koButton.backgroundColor = .clear
        koButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(koButton)
        NSLayoutConstraint.activate([
            koButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
            koButton.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -20),
            koButton.widthAnchor.constraint(equalToConstant: 85),
            koButton.heightAnchor.constraint(equalToConstant: 75)
        ])
        view.bringSubviewToFront(koButton)
        koButton.addAction(UIAction { [weak self] _ in
            self?.selectedIndex = 2 // KO tab index
        }, for: .touchUpInside)
    }

    @objc private func updateLogTextView() {
        DispatchQueue.main.async { [weak self] in
            self?.logTextView?.text = Logger.getLogBuffer().suffix(10).joined(separator: "\n")
        }
    }
} 
