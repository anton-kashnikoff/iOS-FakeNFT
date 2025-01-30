import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo _: UISceneSession,
        options _: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        
        let mainTabBarViewController = MainTabBarViewController()
        mainTabBarViewController.setupTabBar()
        
        window.rootViewController = mainTabBarViewController
        window.backgroundColor = .ypWhite
        self.window = window
        window.makeKeyAndVisible()
    }
}
