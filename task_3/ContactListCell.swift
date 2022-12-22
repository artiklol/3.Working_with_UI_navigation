//
//  ContactListCell.swift
//  task_3
//
//  Created by Artem Sulzhenko on 21.12.2022.
//

import UIKit

class ContactListCell: UITableViewCell {

    static let cellIdentifier = "contactList"

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(
                equalTo: contentView.leftAnchor, constant: 15),
            titleLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor, constant: 15),
            titleLabel.rightAnchor.constraint(
                equalTo: contentView.rightAnchor, constant: -15),
            titleLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor, constant: -15)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
