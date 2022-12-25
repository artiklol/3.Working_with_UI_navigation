//
//  FavoriteСontactsViewController.swift
//  task_3
//
//  Created by Artem Sulzhenko on 19.12.2022.
//

import UIKit

class FavoriteСontactsViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorInset = .zero
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private lazy var contactList = StorageManager.shared.getUserDataFile()
    private lazy var indexesActiveFavorite: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.register(ContactListCell.self, forCellReuseIdentifier: ContactListCell.cellIdentifier)
        tableView.dataSource = self

        setConstraint()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateIndexesActiveFavorite()
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

    private func updateIndexesActiveFavorite() {
        indexesActiveFavorite = []
        for index in 0..<contactList.count where contactList[index].favorite {
                indexesActiveFavorite.append(index)
        }
    }

    @objc func favoriteButtonTapped(sender: UIButton) {
        let buttonTag = sender.tag

        updateIndexesActiveFavorite()

        if contactList[indexesActiveFavorite[buttonTag]].favorite {
            contactList[indexesActiveFavorite[buttonTag]].favorite = false
        } else {
            contactList[indexesActiveFavorite[buttonTag]].favorite = true
        }

        StorageManager.shared.updateFavoriteDataToFile(index: indexesActiveFavorite[buttonTag],
                                            bool: contactList[indexesActiveFavorite[buttonTag]].favorite)
        contactList = StorageManager.shared.getUserDataFile()
        tableView.reloadData()
    }
}

extension FavoriteСontactsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactList.filter { $0.favorite == true }.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactListCell.cellIdentifier,
                                                       for: indexPath) as? ContactListCell else {
            let cell = ContactListCell()
            return cell
        }
        updateIndexesActiveFavorite()

        cell.dataInCell(contact: contactList[indexesActiveFavorite[indexPath.row]])
        cell.settingFavoriteButton().tag = indexPath.row
        cell.settingFavoriteButton().addTarget(self, action: #selector(favoriteButtonTapped(sender:)),
                                      for: .touchUpInside)

        return cell
    }
}
