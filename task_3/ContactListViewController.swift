//
//  ContactListViewController.swift
//  task_3
//
//  Created by Artem Sulzhenko on 19.12.2022.
//

import UIKit
import Contacts

class ContactListViewController: UIViewController {

    private lazy var downloadContactsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.layer.cornerRadius = 15
        button.setTitle("Download contacts".localized(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(downloadContactsButtonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorInset = .zero
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private lazy var authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
    private lazy var contactList = StorageManager.shared.getUserDataFile()
    private lazy var longPressRecognizer = UILongPressGestureRecognizer(target: self,
                                                                        action: #selector(longPress(sender:)))

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Contact list".localized()

        view.addSubview(tableView)
        view.addSubview(downloadContactsButton)
        tableView.register(ContactListCell.self, forCellReuseIdentifier: ContactListCell.cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addGestureRecognizer(longPressRecognizer)

        setConstraint()
        checkAuthorizationStatus()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contactList = StorageManager.shared.getUserDataFile()
        tableView.reloadData()
    }

    private func setConstraint() {
        NSLayoutConstraint.activate([
            downloadContactsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadContactsButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            downloadContactsButton.widthAnchor.constraint(equalToConstant: 200),
            downloadContactsButton.heightAnchor.constraint(equalToConstant: 50),

            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }

    private func hiddenDownloadButtonProperties() {
        if StorageManager.shared.getUserDataFile().isEmpty {
            downloadContactsButton.isHidden = false
        } else {
            downloadContactsButton.isHidden = true
        }
    }

    private func checkAuthorizationStatus() {
        switch authorizationStatus {
        case .authorized:
            hiddenDownloadButtonProperties()
        case .denied:
            showSettingsAlert()
            hiddenDownloadButtonProperties()
        case .notDetermined:
            downloadContactsButton.isHidden = false
        default:
            break
        }
    }

    private func showSettingsAlert() {
        let message = "To continue working, this application requires access to contacts. ".localized() +
        "Do you want to grant permission?".localized()
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Open settings".localized(), style: .default) { _ in
            if let urlSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(urlSetting)
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    private func showMenuAlert(index: Int) {
        let alert = UIAlertController(title: contactList[index].name,
                                      message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Copy phone number".localized(), style: .default) { _ in
            UIPasteboard.general.string = self.contactList[index].phoneNumber
        })
        alert.addAction(UIAlertAction(title: "Share phone number".localized(), style: .default) { _ in
            let items = ["\(self.contactList[index].phoneNumber)"]
            let activityViewController = UIActivityViewController(activityItems: items,
                                                                  applicationActivities: nil)
            self.present(activityViewController, animated: true)
        })
        alert.addAction(UIAlertAction(title: "Delete contact".localized(), style: .destructive) { _ in
            self.contactList.remove(at: index)
            StorageManager.shared.deleteElementDataToFile(index: index)
            self.tableView.reloadData()
            if self.contactList.isEmpty {
                self.downloadContactsButton.isHidden = false
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    @objc func longPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                showMenuAlert(index: indexPath.row)
            }
        }
    }

    @objc func downloadContactsButtonTapped() {
        switch authorizationStatus {
        case.authorized:
            getContacList()
            downloadContactsButton.isHidden = true
        case .denied:
            showSettingsAlert()
        case .notDetermined:
            CNContactStore().requestAccess(for: .contacts) { (success, _) in
                DispatchQueue.main.async {
                    if success {
                        self.getContacList()
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

extension ContactListViewController {
    private func getContacList() {
        var contactsResult: [Contact] = []

        let predicate = CNContact.predicateForContactsInContainer(
            withIdentifier: CNContactStore().defaultContainerIdentifier())
        let contacts = try? CNContactStore().unifiedContacts(matching: predicate, keysToFetch: [
            CNContactGivenNameKey as CNKeyDescriptor,
            CNContactFamilyNameKey as CNKeyDescriptor,
            CNContactPhoneNumbersKey as CNKeyDescriptor,
            CNContactThumbnailImageDataKey as CNKeyDescriptor
        ])

        guard let contacts = contacts else { return }

        for contact in contacts {
            var phoneNumber = ""
            for phoneNumbersString in contact.phoneNumbers {
                phoneNumber = phoneNumbersString.value.stringValue
            }
            let element = Contact(name: contact.givenName,
                                  surname: contact.familyName,
                                  phoneNumber: formatingPhoneNumber(number: phoneNumber),
                                  image: contact.thumbnailImageData,
                                  favorite: false)

            contactsResult.append(element)
        }

        StorageManager.shared.saveDataToFile(contactsResult)
        contactList = StorageManager.shared.getUserDataFile()
        tableView.reloadData()
    }

    private func formatingPhoneNumber(number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let exampleOfFormatting = "+XXX XX XXX XX XX"

        var result = ""
        var index = cleanPhoneNumber.startIndex
        for symbol in exampleOfFormatting where index < cleanPhoneNumber.endIndex {
            if symbol == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(symbol)
            }
        }
        return result
    }
}

extension ContactListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contactList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactListCell.cellIdentifier,
                                                       for: indexPath) as? ContactListCell else {
            let cell = ContactListCell()
            return cell
        }

        cell.dataInCell(contact: contactList[indexPath.row])
        cell.settingFavoriteButton().tag = indexPath.row
        cell.settingFavoriteButton().addTarget(self, action: #selector(favoriteButtonTapped(sender:)),
                                               for: .touchUpInside)

        return cell
    }

    @objc func favoriteButtonTapped(sender: UIButton) {
        let buttonTag = sender.tag

        if contactList[buttonTag].favorite {
            contactList[buttonTag].favorite = false
        } else {
            contactList[buttonTag].favorite = true
        }

        StorageManager.shared.updateFavoriteDataToFile(index: buttonTag, bool: contactList[buttonTag].favorite)
        tableView.reloadData()
    }
}

extension ContactListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsViewController = DetailsViewController(detailElement: contactList[indexPath.row],
                                                          indexContact: indexPath.row)
        navigationController?.pushViewController(detailsViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
