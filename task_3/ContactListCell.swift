//
//  ContactListCell.swift
//  task_3
//
//  Created by Artem Sulzhenko on 21.12.2022.
//

import UIKit

class ContactListCell: UITableViewCell {

    static let cellIdentifier = "contactList"

    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var iconInCircleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: CGFloat.random(in: 0...1),
                                       green: CGFloat.random(in: 0...1),
                                       blue: CGFloat.random(in: 0...1),
                                       alpha: 1.0)
        view.frame.size.height = 25
        view.layer.cornerRadius = view.frame.height
        view.clipsToBounds = true
        return view
    }()
    lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(15)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .none
        button.layer.cornerRadius = 15
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 15
        return stackView
    }()
    var statusFavorite = true
    private var indexCell = 0

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(mainStackView)
        iconInCircleView.addSubview(iconImageView)
        labelsStackView.addArrangedSubview(fullNameLabel)
        labelsStackView.addArrangedSubview(phoneNumberLabel)
        mainStackView.addArrangedSubview(iconInCircleView)
        mainStackView.addArrangedSubview(labelsStackView)
        mainStackView.addArrangedSubview(favoriteButton)

        NSLayoutConstraint.activate([
            mainStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            mainStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),

            iconImageView.topAnchor.constraint(equalTo: iconInCircleView.topAnchor, constant: 10),
            iconImageView.leadingAnchor.constraint(equalTo: iconInCircleView.leadingAnchor, constant: 10),
            iconImageView.trailingAnchor.constraint(equalTo: iconInCircleView.trailingAnchor, constant: -10),
            iconImageView.bottomAnchor.constraint(equalTo: iconInCircleView.bottomAnchor, constant: -10),

            iconInCircleView.widthAnchor.constraint(equalToConstant: 50),
            iconInCircleView.heightAnchor.constraint(equalToConstant: 50),

            favoriteButton.widthAnchor.constraint(equalToConstant: 50),
            favoriteButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setIconFavorite(nameIcon: String) {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20)
        let heartIcon = UIImage(systemName: nameIcon, withConfiguration: largeConfig)
        favoriteButton.setImage(heartIcon, for: .normal)
    }

    func selectCell(index: Int) {
        indexCell = index
    }

    func checkStatusFavoriteButton() {
        if statusFavorite {
            setIconFavorite(nameIcon: "heart.fill")
        } else {
            setIconFavorite(nameIcon: "heart")
        }
    }

    @objc func favoriteButtonTapped() {
        if statusFavorite {
            statusFavorite = false
            setIconFavorite(nameIcon: "heart")
        } else {
            statusFavorite = true
            setIconFavorite(nameIcon: "heart.fill")
        }

        StorageManager.shared.updateFavoriteDataToFile(index: indexCell, bool: statusFavorite)
    }
}
