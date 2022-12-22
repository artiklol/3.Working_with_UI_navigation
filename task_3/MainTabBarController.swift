//
//  MainTabBarController.swift
//  task_3
//
//  Created by Artem Sulzhenko on 19.12.2022.
//

import UIKit
import Contacts

class MainTabBarController: UITabBarController {

    private lazy var downloadContactsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.layer.cornerRadius = 15
        button.setTitle("Загрузить контакты", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(downloadContactsButtonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(downloadContactsButton)
        checkAuthorizationStatus()
        setConstraint()
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
        downloadContactsButton.isHidden = true
    }

    private func generateViewController(viewController: UIViewController, title: String,
                                        defaultImage: UIImage?, selectedImage: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = defaultImage
        viewController.tabBarItem.selectedImage = selectedImage
        return viewController
    }

    private func checkAuthorizationStatus() {
        switch authorizationStatus {
        case .authorized:
            if StorageManager.shared.getUserDataFile().isEmpty {
                view.backgroundColor = .systemPink
                tabBar.isHidden = true
            } else {
                showTabBar()
            }
        case .denied:
            view.backgroundColor = .systemPink
            tabBar.isHidden = true
        case .notDetermined:
            view.backgroundColor = .systemPink
            tabBar.isHidden = true
        default:
            break
        }
    }

    private func setConstraint() {
        NSLayoutConstraint.activate([
            downloadContactsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadContactsButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            downloadContactsButton.widthAnchor.constraint(equalToConstant: 200),
            downloadContactsButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func getContacList() {
        var contactsTest: [Contact] = []

        let predicate = CNContact.predicateForContactsInContainer(
            withIdentifier: CNContactStore().defaultContainerIdentifier())
        let contacts = try? CNContactStore().unifiedContacts(matching: predicate, keysToFetch: [
            CNContactGivenNameKey as CNKeyDescriptor,
            CNContactFamilyNameKey as CNKeyDescriptor,
            CNContactPhoneNumbersKey as CNKeyDescriptor
        ])

        guard let contacts = contacts else { return }

        for contact in contacts {
            var phoneNumber = ""
            for phoneNumbersString in contact.phoneNumbers {
                phoneNumber = phoneNumbersString.value.stringValue
            }
            let element = Contact(name: contact.givenName,
                                  surname: contact.familyName,
                                  phoneNumber: phoneNumber)

            contactsTest.append(element)
        }

        print("1: \(contactsTest.count)")
        StorageManager.shared.saveDataToFile(contactsTest)
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

    @objc func downloadContactsButtonTapped() {
        switch authorizationStatus {
        case.authorized:
            getContacList()
            showTabBar()
        case .denied:
            showSettingsAlert()
        case .notDetermined:
            CNContactStore().requestAccess(for: .contacts) { (success, _) in
                DispatchQueue.main.async {
                    if success {
                        self.getContacList()
                        self.showTabBar()
                    } else {
                        self.authorizationStatus = .denied
                    }
                }
            }
        default:
            break
        }
    }
}
