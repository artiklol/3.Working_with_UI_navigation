//
//  MainTabBarController.swift
//  task_3
//
//  Created by Artem Sulzhenko on 19.12.2022.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        showTabBar()
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let barButtonView = item.value(forKey: "view") as? UIView else { return }

        let animationLength: TimeInterval = 0.3
        let propertyAnimator = UIViewPropertyAnimator(duration: animationLength, dampingRatio: 0.5) {
            barButtonView.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
        }
        propertyAnimator.addAnimations({ barButtonView.transform = .identity },
                                       delayFactor: CGFloat(animationLength))
        propertyAnimator.startAnimation()
    }

    private func showTabBar() {
        let contactListNavigationController = UINavigationController(
            rootViewController: ContactListViewController())
        viewControllers = [
            generateViewController(
                viewController: contactListNavigationController,
                title: "Contacts".localized(),
                defaultImage: UIImage(systemName: "phone"),
                selectedImage: UIImage(systemName: "phone.fill")
            ),
            generateViewController(
                viewController: FavoriteСontactsViewController(),
                title: "Favorites".localized(),
                defaultImage: UIImage(systemName: "star"),
                selectedImage: UIImage(systemName: "star.fill")
            )
        ]
        tabBar.backgroundColor = .white
        UITabBar.appearance().tintColor = .red
    }

    private func generateViewController(viewController: UIViewController, title: String,
                                        defaultImage: UIImage?, selectedImage: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = defaultImage
        viewController.tabBarItem.selectedImage = selectedImage
        return viewController
    }
}
