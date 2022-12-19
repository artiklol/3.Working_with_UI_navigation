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
        createTabBar()
        tabBar.backgroundColor = .white
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let barButtonView = item.value(forKey: "view") as? UIView else {
            return
        }

        let animationLength: TimeInterval = 0.3
        let propertyAnimator = UIViewPropertyAnimator(duration: animationLength,
                                                      dampingRatio: 0.5) {
            barButtonView.transform = CGAffineTransform.identity.scaledBy(x: 0.9,
                                                                          y: 0.9)
        }
        propertyAnimator.addAnimations({ barButtonView.transform = .identity },
                                       delayFactor: CGFloat(animationLength))
        propertyAnimator.startAnimation()
    }

    private func createTabBar() {
        viewControllers = [
            generateVC(
                viewController: ContactListViewController(),
                title: "Contact",
                defaultImage: UIImage(systemName: "phone"),
                selectedImage: UIImage(systemName: "phone.fill")
            ),
            generateVC(
                viewController: FavoriteСontactsViewController(),
                title: "Favorite",
                defaultImage: UIImage(systemName: "star"),
                selectedImage: UIImage(systemName: "star.fill")
            )
        ]
    }

    private func generateVC(viewController: UIViewController,
                            title: String,
                            defaultImage: UIImage?,
                            selectedImage: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = defaultImage
        viewController.tabBarItem.selectedImage = selectedImage
        return viewController
    }

}
