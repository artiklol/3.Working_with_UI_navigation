//
//  DetailsViewController.swift
//  task_3
//
//  Created by Artem Sulzhenko on 23.12.2022.
//

import UIKit

class DetailsViewController: UIViewController {

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        if let imageData = detailContact.image {
            imageView.image = UIImage(data: imageData)
        } else {
            imageView.image = imageInitials()
        }
        return imageView
    }()
    private lazy var iconInCircleView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        view.frame.size.height = 50
        view.layer.cornerRadius = view.frame.height
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var informationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 3
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private lazy var nameTitleLabel = UILabel()
    private lazy var nameTextField = UITextField()
    private lazy var surnameTitleLabel = UILabel()
    private lazy var surnameTextField = UITextField()
    private lazy var phoneNumberTitleLabel = UILabel()
    private lazy var phoneNumberTextField = UITextField()
    private lazy var editButton = UIBarButtonItem(title: "Edit".localized(), style: .plain, target: self,
                                                  action: #selector(editButtonTapped))
    private var detailContact: Contact
    private var indexContact: Int

    init(detailElement: Contact, indexContact: Int) {
        self.detailContact = detailElement
        self.indexContact = indexContact
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        iconInCircleView.addSubview(iconImageView)
        view.addSubview(iconInCircleView)
        informationStackView.addArrangedSubview(nameTitleLabel)
        informationStackView.addArrangedSubview(nameTextField)
        informationStackView.addArrangedSubview(surnameTitleLabel)
        informationStackView.addArrangedSubview(surnameTextField)
        informationStackView.addArrangedSubview(phoneNumberTitleLabel)
        informationStackView.addArrangedSubview(phoneNumberTextField)
        view.addSubview(informationStackView)

        setConstraint()
        setSettingNavigationBar()
        setSettingLabel(label: nameTitleLabel, title: "Name".localized())
        setSettingLabel(label: surnameTitleLabel, title: "Surname".localized())
        setSettingLabel(label: phoneNumberTitleLabel, title: "Phone Number".localized())
        setSettingTextField(textField: nameTextField, text: detailContact.name)
        setSettingTextField(textField: surnameTextField, text: detailContact.surname)
        setSettingTextField(textField: phoneNumberTextField, text: detailContact.phoneNumber)

        registerForKeyboardNotifications()
        setupKeyboard(textField: nameTextField)
        setupKeyboard(textField: surnameTextField)
        setupKeyboard(textField: phoneNumberTextField)
    }

    deinit {
        removeKeyboardNotifications()
    }

    private func setConstraint() {
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: iconInCircleView.topAnchor, constant: 0),
            iconImageView.leadingAnchor.constraint(equalTo: iconInCircleView.leadingAnchor, constant: 0),
            iconImageView.trailingAnchor.constraint(equalTo: iconInCircleView.trailingAnchor, constant: 0),
            iconImageView.bottomAnchor.constraint(equalTo: iconInCircleView.bottomAnchor, constant: 0),

            iconInCircleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconInCircleView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            iconInCircleView.widthAnchor.constraint(equalToConstant: 100),
            iconInCircleView.heightAnchor.constraint(equalToConstant: 100),

            informationStackView.topAnchor.constraint(equalTo: iconInCircleView.bottomAnchor, constant: 10),
            informationStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            nameTextField.widthAnchor.constraint(equalToConstant: 200),
            nameTextField.heightAnchor.constraint(equalToConstant: 28),
            surnameTextField.widthAnchor.constraint(equalToConstant: 200),
            surnameTextField.heightAnchor.constraint(equalToConstant: 28),
            phoneNumberTextField.widthAnchor.constraint(equalToConstant: 200),
            phoneNumberTextField.heightAnchor.constraint(equalToConstant: 28)
        ])
    }

    private func setSettingNavigationBar() {
        let navigationBar = navigationController?.navigationBar
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = .white

        navigationBar?.standardAppearance = navBarAppearance
        navigationBar?.scrollEdgeAppearance = navBarAppearance

        navigationItem.rightBarButtonItem = editButton
    }

    private func setSettingLabel(label: UILabel, title: String) {
        label.text = title
        label.font = label.font.withSize(15)
        label.textAlignment = .center
    }

    private func setSettingTextField(textField: UITextField, text: String) {
        textField.text = text
        textField.font = textField.font?.withSize(20)
        textField.textAlignment = .center
        textField.isUserInteractionEnabled = false
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
    }

    private func imageInitials() -> UIImage? {
         let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
         let nameLabel = UILabel(frame: frame)
         nameLabel.textAlignment = .center
         nameLabel.backgroundColor = .lightGray
         nameLabel.textColor = .white
         nameLabel.font = UIFont.boldSystemFont(ofSize: 40)
         nameLabel.text = "\(detailContact.name.prefix(1))\(detailContact.surname.prefix(1))"
         UIGraphicsBeginImageContext(frame.size)
          if let currentContext = UIGraphicsGetCurrentContext() {
             nameLabel.layer.render(in: currentContext)
             let nameImage = UIGraphicsGetImageFromCurrentImageContext()
             return nameImage
          }
          return nil
    }

    @objc func editButtonTapped() {
        donePressed()

        if nameTextField.isUserInteractionEnabled {
            nameTextField.isUserInteractionEnabled = false
            surnameTextField.isUserInteractionEnabled = false
            phoneNumberTextField.isUserInteractionEnabled = false
            editButton.title = "Edit".localized()
            detailContact.name = nameTextField.text ?? "Error Name"
            detailContact.surname = surnameTextField.text ?? "Error Surname"
            detailContact.phoneNumber = phoneNumberTextField.text ?? "Error Phone Number"

            StorageManager.shared.updateInfoDataToFile(index: indexContact, element: detailContact)
        } else {
            nameTextField.isUserInteractionEnabled = true
            surnameTextField.isUserInteractionEnabled = true
            phoneNumberTextField.isUserInteractionEnabled = true
            editButton.title = "Save".localized()
        }
    }
}

extension DetailsViewController: UITextFieldDelegate {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        view.endEditing(true)
    }

    private func setupKeyboard(textField: UITextField) {
        textField.delegate = self

        let bar = UIToolbar()
        let done = UIBarButtonItem(title: "Done".localized(), style: .plain, target: self,
                                   action: #selector(donePressed))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        bar.items = [flexibleSpace, done]
        bar.sizeToFit()

        textField.inputAccessoryView = bar
    }

    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }

    @objc func hideKeyboard() {
        view.frame.origin.y = 0
    }

    @objc func showKeyboard(_ notification: Notification) {
        guard let keyboardFrameSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
                                       as? NSValue)?.cgRectValue else { return }
        view.frame.origin.y = -keyboardFrameSize.height/2 - 50
    }

    @objc private func donePressed() {
        view.endEditing(true)
    }
}
