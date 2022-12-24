//
//  DetailsViewController.swift
//  task_3
//
//  Created by Artem Sulzhenko on 23.12.2022.
//

import UIKit

class DetailsViewController: UIViewController {

    private var detailContact: Contact
    private var indexContact: Int

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        if let imageData = detailContact.image {
            imageView.image = UIImage(data: imageData)
        } else {
            imageView.image = UIImage(named: "face")
        }
        return imageView
    }()
    private lazy var iconInCircleView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
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
    private lazy var editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self,
                                                  action: #selector(editButtonTapped))

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
        setSettingLabel(label: nameTitleLabel, title: "Name")
        setSettingLabel(label: surnameTitleLabel, title: "Surname")
        setSettingLabel(label: phoneNumberTitleLabel, title: "Phone Number")
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
            iconImageView.topAnchor.constraint(equalTo: iconInCircleView.topAnchor, constant: 20),
            iconImageView.leadingAnchor.constraint(equalTo: iconInCircleView.leadingAnchor, constant: 20),
            iconImageView.trailingAnchor.constraint(equalTo: iconInCircleView.trailingAnchor, constant: -20),
            iconImageView.bottomAnchor.constraint(equalTo: iconInCircleView.bottomAnchor, constant: -20),

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

    @objc func editButtonTapped() {
        donePressed()

        if nameTextField.isUserInteractionEnabled {
            nameTextField.isUserInteractionEnabled = false
            surnameTextField.isUserInteractionEnabled = false
            phoneNumberTextField.isUserInteractionEnabled = false
            editButton.title = "Edit"
            detailContact.name = nameTextField.text ?? "Error Name"
            detailContact.surname = surnameTextField.text ?? "Error Surname"
            detailContact.phoneNumber = phoneNumberTextField.text ?? "Error Phone Number"

            StorageManager.shared.updateInfoDataToFile(index: indexContact, element: detailContact)
        } else {
            nameTextField.isUserInteractionEnabled = true
            surnameTextField.isUserInteractionEnabled = true
            phoneNumberTextField.isUserInteractionEnabled = true
            editButton.title = "Save"
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
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self,
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
        view.frame.origin.y = -keyboardFrameSize.height/2
    }

    @objc private func donePressed() {
        view.endEditing(true)
    }
}
