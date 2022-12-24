//
//  ContactListViewController.swift
//  task_3
//
//  Created by Artem Sulzhenko on 19.12.2022.
//

import UIKit

class ContactListViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorInset = .zero
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private lazy var contactList = StorageManager.shared.getUserDataFile()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Список контактов"
        view.addSubview(tableView)
        tableView.register(ContactListCell.self, forCellReuseIdentifier: ContactListCell.cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self

        setConstraint()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contactList = StorageManager.shared.getUserDataFile()
        tableView.reloadData()
    }

    private func setConstraint() {
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
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
        cell.dataInCell(contact: contact)
        cell.settingFavoriteButton().tag = indexPath.row
        cell.settingFavoriteButton().addTarget(self, action: #selector(favoriteButtonTapped(sender:)),
                                      for: .touchUpInside)
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
