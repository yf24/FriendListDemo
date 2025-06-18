import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupViewControllers() {
        // 錢錢
        let moneyVC = UIViewController()
        moneyVC.view.backgroundColor = .white
        moneyVC.tabBarItem = UITabBarItem(title: "錢錢", image: UIImage(systemName: "dollarsign.circle"), tag: 0)
        
        // 朋友
        let friendListVC = FriendListViewController()
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
} 