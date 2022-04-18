//
//  UIView+CustomTextField.swift
//  Musification
//
//  Created by Георгий Рыбак on 14.02.22.
//

import Foundation

import UIKit
import SnapKit

enum CustomTextFieldStyle {
    case email
    case userName
    case password
    case confirmPassword
    case emailOrUsername
}

class CustomTextField: UIView, UITextFieldDelegate {
    // MARK: - Constants
    private enum Constants {
        static let offset = 20
    }

    // MARK: - UI property
    private var eyeOff = true
    private let contentView = UIView()
    private let placeholderLabel = UILabel()
    private let textfield = UITextField()
    private let placeholderImageView = UIImageView()
    private let eyeButton = UIButton()

    var endEditingCallBack: ((String, CustomTextFieldStyle) -> Void)?

    var style: CustomTextFieldStyle? {
        didSet {
            guard let style = self.style else { return }
            configureStyle(style: style)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        textfield.delegate = self
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        setupLayout()
    }

    private func setupLayout() {
        addSubviews([placeholderLabel, placeholderImageView, eyeButton, textfield])

        self.snp.makeConstraints {
            $0.height.equalTo(Constants.offset * 2)
        }
        placeholderImageView.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.leading.equalToSuperview().offset(Constants.offset)
            maker.width.height.equalTo(Constants.offset)
        }
        eyeButton.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.trailing.equalToSuperview().offset(-Constants.offset)
            maker.width.height.equalTo(Constants.offset)
        }
        placeholderLabel.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.leading.equalTo(placeholderImageView.snp.trailing).offset(Constants.offset / 2)
            maker.trailing.equalTo(eyeButton.snp.leading).offset(-(Constants.offset / 2))
        }
        textfield.snp.makeConstraints { maker in
            maker.leading.trailing.bottom.top.equalTo(placeholderLabel)
        }

        clipsToBounds = true
        backgroundColor = Color.secondary2
        layer.cornerRadius = bounds.size.height / 2
        placeholderLabel.textColor = Color.secondary1
        eyeButton.setImage(UIImage(named: "eye"), for: .normal)
        eyeButton.addTarget(self, action: #selector(makeEyeOn), for: .touchUpInside)
        textfield.textColor = .white
        layer.borderWidth = 2
        layer.borderColor = UIColor.clear.cgColor
    }

    @objc private func makeEyeOn() {
        if !eyeOff {
            eyeButton.setImage(UIImage(named: "eye"), for: .normal)
            eyeOff = true
            textfield.isSecureTextEntry = true
        } else {
            eyeButton.setImage(UIImage(named: "eye-off"), for: .normal)
            eyeOff = false
            textfield.isSecureTextEntry = false
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        placeholderLabel.isHidden = true
        layer.borderColor = Color.secondary1?.cgColor
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        layer.borderColor = UIColor.clear.cgColor
        guard let text = textfield.text, let style = self.style else { return }
        placeholderLabel.isHidden = !text.isEmpty
        endEditingCallBack?(text, style)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }

    func hideKeyboard() {
        textfield.resignFirstResponder()
    }

    func isFillingError(condition: Bool) {
        switch condition {
        case true:
            layer.borderColor = Color.error?.cgColor
        case false:
            layer.borderColor = UIColor.clear.cgColor
        }
    }

    private func configureStyle(style: CustomTextFieldStyle) {
        switch style {
        case .email:
            placeholderLabel.text = "Email"
            placeholderImageView.image = UIImage(named: "mail")
            textfield.isSecureTextEntry = false
            eyeButton.isHidden = true
            textfield.textContentType = .emailAddress
        case .userName:
            placeholderLabel.text = "username".localized(withComment: nil)
            placeholderImageView.image = UIImage(named: "user")
            textfield.isSecureTextEntry = false
            eyeButton.isHidden = true
            textfield.textContentType = .username
        case .emailOrUsername:
            placeholderLabel.text = "emailOrUsername".localized(withComment: nil)
            placeholderImageView.image = UIImage(named: "user")
            textfield.isSecureTextEntry = false
            eyeButton.isHidden = true
            textfield.textContentType = .username
        case .password:
            placeholderLabel.text = "password".localized(withComment: nil)
            placeholderImageView.image = UIImage(named: "lock")
            textfield.isSecureTextEntry = true
            eyeButton.isHidden = false
            textfield.textContentType = .password
        case .confirmPassword:
            placeholderLabel.text = "confPasword".localized(withComment: nil)
            placeholderImageView.image = UIImage(named: "lock")
            textfield.isSecureTextEntry = true
            eyeButton.isHidden = false
            textfield.textContentType = .password
        }
    }
}
