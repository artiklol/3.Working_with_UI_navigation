//
//  ContactListCell.swift
//  task_3
//
//  Created by Artem Sulzhenko on 21.12.2022.
//

import UIKit

class ContactListCell: UITableViewCell {

    static let cellIdentifier = "contactList"

    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 15
        return stackView
    }()
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var iconInCircleView: UIView = {
        let view = UIView()
        view.frame.size.height = 25
        view.layer.cornerRadius = view.frame.height
        view.clipsToBounds = true
        return view
    }()
    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()
    private lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(15)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .none
        button.layer.cornerRadius = 15
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var statusFavorite = true

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(mainStackView)
        iconInCircleView.addSubview(iconImageView)
        labelsStackView.addArrangedSubview(fullNameLabel)
        labelsStackView.addArrangedSubview(phoneNumberLabel)
        mainStackView.addArrangedSubview(iconInCircleView)
        mainStackView.addArrangedSubview(labelsStackView)
        mainStackView.addArrangedSubview(favoriteButton)

        setConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setConstraint() {
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: iconInCircleView.topAnchor, constant: 0),
            iconImageView.leadingAnchor.constraint(equalTo: iconInCircleView.leadingAnchor, constant: 0),
            iconImageView.trailingAnchor.constraint(equalTo: iconInCircleView.trailingAnchor, constant: 0),
            iconImageView.bottomAnchor.constraint(equalTo: iconInCircleView.bottomAnchor, constant: 0),

            mainStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            mainStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            iconInCircleView.widthAnchor.constraint(equalToConstant: 50),
            iconInCircleView.heightAnchor.constraint(equalToConstant: 50),

            favoriteButton.widthAnchor.constraint(equalToConstant: 50),
            favoriteButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setSizeIconFavorite(nameIcon: String) {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20)
        let heartIcon = UIImage(systemName: nameIcon, withConfiguration: largeConfig)
        favoriteButton.setImage(heartIcon, for: .normal)
    }

    private func imageInitials(name: String?) -> UIImage? {
         let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
         let nameLabel = UILabel(frame: frame)
         nameLabel.textAlignment = .center
         nameLabel.backgroundColor = .lightGray
         nameLabel.textColor = .white
         nameLabel.font = UIFont.boldSystemFont(ofSize: 40)
         nameLabel.text = name
         UIGraphicsBeginImageContext(frame.size)
          if let currentContext = UIGraphicsGetCurrentContext() {
             nameLabel.layer.render(in: currentContext)
             let nameImage = UIGraphicsGetImageFromCurrentImageContext()
             return nameImage
          }
          return nil
    }

    func dataInCell(contact: Contact) {
        fullNameLabel.text = "\(contact.name) \(contact.surname)"
        phoneNumberLabel.text = "\(contact.phoneNumber)"
        statusFavorite = contact.favorite
        let initialsFullname = "\(contact.name.prefix(1))\(contact.surname.prefix(1))"

        if let imageData = contact.image {
            iconImageView.image = UIImage(data: imageData)
        } else {
            iconImageView.image = imageInitials(name: initialsFullname)
        }

        if statusFavorite {
            setSizeIconFavorite(nameIcon: "heart.fill")
        } else {
            setSizeIconFavorite(nameIcon: "heart")
        }
    }

    func settingFavoriteButton() -> UIButton {
        return favoriteButton
    }

}
