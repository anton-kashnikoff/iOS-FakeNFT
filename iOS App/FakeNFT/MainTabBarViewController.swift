import UIKit

final class MainTabBarViewController: UITabBarController {
    // MARK: - Private Properties

    private let statisticVC = UINavigationController(rootViewController: StatisticsViewController())
    private let cartVC = UINavigationController(rootViewController: CartViewController())
    private let profileVC = UINavigationController(rootViewController: ProfileViewController())
    private let catalogVC = UINavigationController(rootViewController: CatalogViewController())

    // MARK: - Public Methods

    func setupTabBar() {
        tabBar.unselectedItemTintColor = .ypBlack
        tabBar.backgroundColor = .ypWhite
        tabBar.tintColor = .blueUniversal
        tabBar.barTintColor = .ypWhite

        statisticVC.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(resource: .tabStatistics),
            selectedImage: nil
        )
        
        cartVC.tabBarItem = UITabBarItem(
            title: NSLocalizedString("cartPage.title", tableName: "CartFlowStrings", comment: "Корзина"),
            image: UIImage(resource: .tabCart),
            selectedImage: nil
        )
        cartVC.tabBarItem.accessibilityIdentifier = "cart_tab"
        
        profileVC.tabBarItem = UITabBarItem(
            title: "Профиль",
            image: UIImage(resource: .tabProfile),
            selectedImage: nil
        )
        
        catalogVC.tabBarItem = UITabBarItem(
            title: "Каталог",
            image: UIImage(resource: .tabCatalog),
            selectedImage: nil
        )
        
        setViewControllers([profileVC, catalogVC, cartVC, statisticVC], animated: true)
        selectedIndex = 1
    }
}
