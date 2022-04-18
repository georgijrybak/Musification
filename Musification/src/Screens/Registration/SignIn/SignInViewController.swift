//
//  SignInViewController.swift
//  Musification
//
//  Created by Георгий Рыбак on 11.02.22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import SnapKit

protocol SignInDisplayLogic: AnyObject {
    func displayTextFieldEndEditing(viewModel: SignInModels.TextFieldEndEditingViewModel)
    func displayKeyboardShowing(viewModel: SignInModels.KeyBoardMovingViewModel)
    func displayKeyboardHiding(viewModel: SignInModels.KeyBoardWillHideViewModel)
    func displaySignUpScreen(viewModel: SignInModels.SignUpViewModel)
    func displayResetPasswordScreen(viewModel: SignInModels.ResetPasswordViewModel)
    func displaySignInNotification(viewModel: SignInModels.SignInViewModel)
}

final class SignInViewController: UIViewController {
    // MARK: - Nested Types
    private enum Constants {
        static let offset = 16
        static let textfieldHeight = 40
        static let forgotPasswordButtonHeight = 18
    }

    // MARK: - Properties
    private let interactor: SignInBusinessLogic
    private let router: SignInRoutingLogic

    // MARK: - UI Properties
    private lazy var emailOrUsernameTextField: CustomTextField = {
        let textfield = CustomTextField(frame: .zero)
        textfield.style = .emailOrUsername
        return textfield
    }()

    private lazy var passwordTextField: CustomTextField = {
        let textfield = CustomTextField(frame: .zero)
        textfield.style = .password
        return textfield
    }()

    private lazy var textFieldsArray = [emailOrUsernameTextField, passwordTextField]

    private lazy var textfieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        [
            emailOrUsernameTextField,
            emailOrUsernameError,
            passwordTextField,
            passwordError
        ].forEach { stackView.addArrangedSubview($0) }
        stackView.spacing = 16
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var emailOrUsernameError: UILabel = {
        let label = UILabel()
        label.text = "emailOrUserNameError".localized(withComment: nil)
        label.textColor = Color.error
        label.adjustsFontSizeToFitWidth = true
        label.isHidden = true
        return label
    }()

    private let passwordError: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "passwordErrorText".localized(withComment: nil)
        label.textColor = Color.error
        label.adjustsFontSizeToFitWidth = true
        label.isHidden = true
        return label
    }()

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        return imageView
    }()

    private let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sing in", for: .normal)
        button.backgroundColor = Color.accent
        button.tintColor = .white
        button.layer.cornerRadius = 23
        return button
    }()

    private var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.tintColor = .white
        return button
    }()

    private var forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forgot your password?", for: .normal)
        button.tintColor = .white
        return button
    }()

    private var sigUpLabel: UILabel = {
        let label = UILabel()
        label.text = "Don't have an account?"
        label.textAlignment = .center
        label.textColor = Color.secondary1
        return label
    }()

    private let contentView = UIView()
    private let scrollContentView = UIView()
    private var scrollView = UIScrollView()
    private lazy var notificationView = NotificationView(frame: .zero)

    // MARK: - Initialization
    init(interactor: SignInBusinessLogic, router: SignInRoutingLogic) {
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented in SignInViewController")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        scrollView.alpha = 0
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: [.curveEaseInOut]
        ) { self.scrollView.alpha = 1 }
        keyboardShowingObservering(isEnabled: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        keyboardShowingObservering(isEnabled: false)
    }

    // MARK: - Private Methods
    private func configureView() {
        view.isUserInteractionEnabled = true
        navigationController?.isNavigationBarHidden = true

        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(textFieldEndEditing))
        view.addGestureRecognizer(recognizer)

        view.backgroundColor = Color.main

        setupSubviews()
        setupLayout()
        setupButtonsTargets()
    }

    private func setupSubviews() {
        view.addSubviews([scrollView, notificationView])
        scrollView.addSubview(scrollContentView)
        scrollContentView.addSubviews(
            [
                logoImageView,
                textfieldStackView,
                signInButton,
                forgotPasswordButton,
                contentView
            ]
        )
        contentView.addSubviews([signUpButton, sigUpLabel])
    }

    private func setupLayout() {
        scrollView.snp.makeConstraints { maker in
            maker.left.bottom.top.right.equalTo(view.safeAreaLayoutGuide)
        }
        notificationView.snp.makeConstraints { maker in
            maker.left.bottom.top.right.equalTo(view.safeAreaLayoutGuide)
            maker.bottom.equalTo(view)
        }
        scrollContentView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
            maker.width.equalTo(scrollView.snp.width)
            maker.height.equalTo(scrollView.snp.height).priority(.low)
        }
        logoImageView.snp.makeConstraints { maker in
            maker.centerX.equalTo(scrollContentView)
            maker.height.width.equalTo(199)
            maker.top.equalTo(scrollContentView.snp.top).offset(2 * Constants.offset)
        }
        textfieldStackView.snp.makeConstraints { maker in
            maker.top.equalTo(logoImageView.snp.bottom).offset(2 * Constants.offset)
            maker.left.right.equalToSuperview().inset(16)
        }
        forgotPasswordButton.snp.makeConstraints { maker in
            maker.left.equalTo(textfieldStackView.snp.left)
            maker.width.equalTo(160)
            maker.top.equalTo(textfieldStackView.snp.bottom).offset(Constants.offset)
            maker.height.equalTo(Constants.forgotPasswordButtonHeight)
        }
        contentView.snp.makeConstraints { maker in
            maker.height.equalTo(Constants.forgotPasswordButtonHeight)
            maker.centerX.equalTo(scrollContentView)
            maker.bottom.equalTo(scrollContentView.snp.bottom).offset(-2 * Constants.offset)
            maker.width.equalTo(250)
        }
        signUpButton.snp.makeConstraints { maker in
            maker.bottom.top.trailing.equalToSuperview()
            maker.width.equalTo(60)
        }
        sigUpLabel.snp.makeConstraints { maker in
            maker.left.top.bottom.equalToSuperview()
            maker.trailing.equalTo(signUpButton.snp.leading)
        }
        signInButton.snp.makeConstraints { maker in
            maker.top.greaterThanOrEqualTo(forgotPasswordButton.snp.bottom).offset(10)
            maker.left.right.equalTo(scrollContentView).inset(Constants.offset)
            maker.height.equalTo(46)
            maker.bottom.equalTo(contentView.snp.top).offset(-Constants.offset)
        }
    }

    private func setupButtonsTargets() {
        forgotPasswordButton.addTarget(
            self,
            action: #selector(showResetPasswordScreen),
            for: .touchUpInside
        )
        signInButton.addTarget(
            self,
            action: #selector(signIn),
            for: .touchUpInside
        )
        signUpButton.addTarget(
            self,
            action: #selector(showSignUpScreen),
            for: .touchUpInside
        )
    }

    private func keyboardShowingObservering(isEnabled: Bool) {
        switch isEnabled {
        case true:
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(keyboardWillShow),
                name: UIResponder.keyboardWillShowNotification,
                object: nil
            )
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(keyboardWillHide),
                name: UIResponder.keyboardWillHideNotification,
                object: nil
            )
        case false:
            NotificationCenter.default.removeObserver(
                self,
                name: UIResponder.keyboardWillShowNotification,
                object: nil
            )
            NotificationCenter.default.removeObserver(
                self,
                name: UIResponder.keyboardWillHideNotification,
                object: nil
            )
        }
    }

    private func configError(isError: Bool, textFieldWithFillingError: CustomTextFieldStyle) {
        func showError(position: Int) {
            errorsArray[position].isHidden = !isError
            textfieldStackView.setCustomSpacing(
                CGFloat(Constants.offset) / 2,
                after: textFieldsArray[position]
            )
            textfieldStackView.setCustomSpacing(
                CGFloat(Constants.offset) / 2,
                after: errorsArray[position]
            )
        }

        func hideError(position: Int) {
            errorsArray[position].isHidden = !isError
            textfieldStackView.setCustomSpacing(
                CGFloat(Constants.offset),
                after: textFieldsArray[position]
            )
        }

        let errorsArray = [emailOrUsernameError, passwordError]

        for (index, element) in textFieldsArray.enumerated()
        where element.style == textFieldWithFillingError {
            isError ? showError(position: index) : hideError(position: index)
        }
    }

    // MARK: - Interactor Methods
    @objc private func textFieldEndEditing(_ sender: UITapGestureRecognizer) {
        let request = SignInModels.TextFieldEndEditingRequest()
        interactor.fetchTextFieldEndEditing(request: request)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        let request = SignInModels.KeyBoardMovingRequest(notification: notification)
        interactor.fetchKeyboardShowing(request: request)
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        textFieldsArray.forEach {
            $0.endEditingCallBack = { [weak self] text, style in
                guard let self = self else { return }
                let request = SignInModels.KeyBoardWillHideRequest(
                    notification: notification,
                    textFieldStyle: style,
                    text: text
                )
                self.interactor.fetchKeyboardHiding(request: request)
            }
        }
    }

    @objc private func showSignUpScreen() {
        let request = SignInModels.SignUpRequest()
        interactor.fetchSignUpScreen(request: request)
    }

    @objc private func showResetPasswordScreen() {
        let request = SignInModels.ResetPasswordRequest()
        interactor.fetchResetPasswordScreen(request: request)
    }

// MARK: - TEST FUNCTIONALITY FIREBASE
    @objc private func signIn() {
         let request = SignInModels.SignInRequest()
        interactor.fetchSignInNotification(request: request)
    }
}

// MARK: - SignInDisplayLogic
extension SignInViewController: SignInDisplayLogic {
    func displayKeyboardHiding(viewModel: SignInModels.KeyBoardWillHideViewModel) {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        textFieldsArray.forEach {
            if $0.style == viewModel.textFieldStyle {
                $0.isFillingError(condition: viewModel.isError)
            }
        }
        configError(isError: viewModel.isError, textFieldWithFillingError: viewModel.textFieldStyle)
    }

    func displayKeyboardShowing(viewModel: SignInModels.KeyBoardMovingViewModel) {
        guard
            let userInfo = viewModel.notification.userInfo,
            let nsValue = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue
        else { return }

        var keyboardFrame: CGRect = (nsValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset: UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        scrollView.contentInset = contentInset
    }

    func displayTextFieldEndEditing(viewModel: SignInModels.TextFieldEndEditingViewModel) {
        [emailOrUsernameTextField, passwordTextField].forEach { $0.hideKeyboard() }
    }

    func displaySignUpScreen(viewModel: SignInModels.SignUpViewModel) {
        router.routeToSingUpScreen()
    }

    func displayResetPasswordScreen(viewModel: SignInModels.ResetPasswordViewModel) {
        router.routeToResetPasswordScreen()
    }

    func displaySignInNotification(viewModel: SignInModels.SignInViewModel) {
        viewModel.isSomethingBad ?
            notificationView.showNotification(
                type: viewModel.notificationType,
                message: viewModel.message,
                completion: nil
            ) :
            router.routeToMainScreen()
    }
}
