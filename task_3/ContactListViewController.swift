//
//  ContactListViewController.swift
//  task_3
//
//  Created by Artem Sulzhenko on 19.12.2022.
//

import UIKit

class ContactListViewController: UIViewController {

    var tableView = UITableView()

    var contactList = StorageManager.shared.getUserDataFile()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Список контактов"
        view.addSubview(tableView)
        tableView.register(ContactListCell.self, forCellReuseIdentifier: ContactListCell.cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self

        tableView.translatesAutoresizingMaskIntoConstraints = false

        print(contactList.count)

        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)

        ])
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

        let contact = contactList[indexPath.row]
        cell.fullNameLabel.text = "\(contact.name) \(contact.surname)"
        cell.phoneNumberLabel.text = "\(contact.phoneNumber)"
        cell.selectCell(index: indexPath.row)
        cell.statusFavorite = contact.favorite
        cell.checkStatusFavoriteButton()
        if let imageData = contact.image {
            print("image \(String(describing: UIImage(data: imageData)))")
            cell.iconImageView.image = UIImage(data: imageData)
        } else {
            cell.iconImageView.image = UIImage(named: "face")
        }
        return cell
    }
}

extension ContactListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsViewController = DetailsViewController()
        navigationController?.pushViewController(detailsViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
