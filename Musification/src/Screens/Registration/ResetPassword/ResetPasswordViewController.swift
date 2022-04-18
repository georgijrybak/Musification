//
//  ResetPasswordViewController.swift
//  Musification
//
//  Created by Георгий Рыбак on 21.02.22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ResetPasswordDisplayLogic: AnyObject {
    func displayTextFieldEndEditing(viewModel: ResetPasswordModels.TextEndEditingViewModel)
    func displayKeyboardHiding(viewModel: ResetPasswordModels.KeyBoardWillHideViewModel)
    func displaySignUpNotification(viewModel: ResetPasswordModels.ResetPasswordViewModel)
}

final class ResetPasswordViewController: UIViewController {
    // MARK: - Nested Types
    private enum Constants {
        static let offset = 16
        static let googleURL = "https://www.gmail.com"
    }

    // MARK: - Properties
    private let interactor: ResetPasswordBusinessLogic
    private let router: ResetPasswordRoutingLogic

    // MARK: - UI Properties
    private lazy var emailOrUsernameTextField: CustomTextField = {
        let textfield = CustomTextField(frame: .zero)
        textfield.style = .emailOrUsername
        return textfield
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "forgotPasswordLable".localized(withComment: nil)
        label.textColor = UIColor.white
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private lazy var titleDescription: UILabel = {
        let label = UILabel()
        label.text = "forgotPasswordDescriptionLable".localized(withComment: nil)
        label.textColor = Color.secondary1
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        [
            titleLabel,
            titleDescription,
            emailOrUsernameTextField
        ].forEach { stackView.addArrangedSubview($0) }
        stackView.spacing = 16
        stackView.axis = .vertical
        return stackView
    }()

    private let resetPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("sendResetLink".localized(withComment: nil), for: .normal)
        button.backgroundColor = Color.accent
        button.tintColor = .white
        button.layer.cornerRadius = 23
        return button
    }()

    private let notification = NotificationView(frame: .zero)

    // MARK: - Initialization
    init(interactor: ResetPasswordBusinessLogic, router: ResetPasswordRoutingLogic) {
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented in ResetPasswordViewController")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.isNavigationBarHidden = true
    }

    // MARK: - Private Methods
    private func configureView() {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = Color.main
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]

        view.backgroundColor = Color.main

        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(textFieldEndEditing))
        view.addGestureRecognizer(recognizer)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )

        setupSubviews()
        setupLayout()
    }

    private func setupSubviews() {
        view.addSubviews([contentStackView, resetPasswordButton, notification])
    }

    private func setupLayout() {
        contentStackView.snp.makeConstraints { maker in
            maker.top.left.right.equalTo(view.safeAreaLayoutGuide).inset(Constants.offset)
        }
        resetPasswordButton.snp.makeConstraints { maker in
            maker.left.right.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.offset)
            maker.height.equalTo(46)
        }
        notification.snp.makeConstraints { maker in
            maker.edges.equalTo(view.safeAreaLayoutGuide)
        }

        resetPasswordButton.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
    }

    private func showSafari() {
        if let url = URL(string: Constants.googleURL) {
            UIApplication.shared.open(url)
        }
    }

    // MARK: - Interactor Methods
    @objc private func textFieldEndEditing(_ sender: UITapGestureRecognizer) {
        let request = ResetPasswordModels.TextEndEditingRequest()
        interactor.fetchTextFieldEndEditing(request: request)
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        emailOrUsernameTextField.endEditingCallBack = { [weak self] text, _ in
            guard let self = self else { return }
            let request = ResetPasswordModels.KeyBoardWillHideRequest(
                emailOrUsername: text
            )
            self.interactor.fetchKeyboardHiding(request: request)
        }
    }
    @objc private func resetPassword() {
        let request = ResetPasswordModels.ResetPasswordRequest()
        interactor.fetchSignUpNotification(request: request)
    }
}

// MARK: - ResetPasswordDisplayLogic
extension ResetPasswordViewController: ResetPasswordDisplayLogic {
    func displayTextFieldEndEditing(viewModel: ResetPasswordModels.TextEndEditingViewModel) {
        emailOrUsernameTextField.hideKeyboard()
    }

    func displaySignUpNotification(viewModel: ResetPasswordModels.ResetPasswordViewModel) {
        notification.showNotification(type: viewModel.notificationType, message: viewModel.message) {
            if viewModel.notificationType == .success {
                self.showSafari()
                self.router.back()
            }
        }
    }

    func displayKeyboardHiding(viewModel: ResetPasswordModels.KeyBoardWillHideViewModel) {}
}
