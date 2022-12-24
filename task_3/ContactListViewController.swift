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

        let longPressRecognizer = UILongPressGestureRecognizer(target: self,
                                                               action: #selector(longPress(sender:)))
        tableView.addGestureRecognizer(longPressRecognizer)
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

    @objc func longPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                let alert = UIAlertController(title: contactList[indexPath.row].name,
                                              message: nil, preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Скопировать телефон", style: .default) { _ in
                    UIPasteboard.general.string = self.contactList[indexPath.row].phoneNumber
                })
                alert.addAction(UIAlertAction(title: "Поделиться телефоном", style: .default) { _ in
                    let items = ["\(self.contactList[indexPath.row].phoneNumber)"]
                    let activityViewController = UIActivityViewController(activityItems: items,
                                                                          applicationActivities: nil)
                    self.present(activityViewController, animated: true)
                })
                alert.addAction(UIAlertAction(title: "Удалить контакт", style: .destructive) { _ in
                    self.contactList.remove(at: indexPath.row)
                    StorageManager.shared.deleteElementDataToFile(index: indexPath.row)
                    self.tableView.reloadData()
                })
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

                present(alert, animated: true, completion: nil)
            }

        }
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
}

extension ContactListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsViewController = DetailsViewController(detailElement: contactList[indexPath.row],
                                                          indexContact: indexPath.row)
        navigationController?.pushViewController(detailsViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
