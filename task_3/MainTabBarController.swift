//
//  MainTabBarController.swift
//  task_3
//
//  Created by Artem Sulzhenko on 19.12.2022.
//

import UIKit
import Contacts

class MainTabBarController: UITabBarController {

    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.layer.cornerRadius = 15
        button.setTitle("Загрузить контакты", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    private let authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)

    override func viewDidLoad() {
        super.viewDidLoad()

        switch authorizationStatus {
        case .authorized:
            showTabBar()
        case .denied:
            view.backgroundColor = .systemPink
            tabBar.isHidden = true
        case .notDetermined:
            view.backgroundColor = .systemPink
            tabBar.isHidden = true
        default:
            break
        }

        view.addSubview(startButton)

        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            startButton.widthAnchor.constraint(equalToConstant: 200),
            startButton.heightAnchor.constraint(equalToConstant: 50)
        ])

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
        viewControllers = [
            generateViewController(
                viewController: ContactListViewController(),
                title: "Contact",
                defaultImage: UIImage(systemName: "phone"),
                selectedImage: UIImage(systemName: "phone.fill")
            ),
            generateViewController(
                viewController: FavoriteСontactsViewController(),
                title: "Favorite",
                defaultImage: UIImage(systemName: "star"),
                selectedImage: UIImage(systemName: "star.fill")
            )
        ]
        tabBar.backgroundColor = .white
        tabBar.isHidden = false
        startButton.isHidden = true
    }

    private func generateViewController(viewController: UIViewController,
                                        title: String,
                                        defaultImage: UIImage?,
                                        selectedImage: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = defaultImage
        viewController.tabBarItem.selectedImage = selectedImage
        return viewController
    }

    private func showSettingsAlert() {
        let msg = "To continue working, this application requires access to contacts. " +
        "Do you want to grant permission?"
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let urlSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(urlSetting)
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    @objc func buttonTapped() {
        switch authorizationStatus {
        case .authorized:
            showTabBar()
        case .denied:
            showSettingsAlert()
        case .notDetermined:
            CNContactStore().requestAccess(for: .contacts) { (success, _) in
                DispatchQueue.main.async {
                    success ? self.showTabBar() : self.showSettingsAlert()
                }
            }
        default:
            break
        }
    }
}
