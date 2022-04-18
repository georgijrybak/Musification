//
//  SignUpViewController.swift
//  Musification
//
//  Created by Георгий Рыбак on 15.02.22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SignUpDisplayLogic: AnyObject {
    func displayTextFieldEndEditing(viewModel: SignUpModels.TextFieldEndEditingViewModel)
    func displayKeyboardShowing(viewModel: SignUpModels.KeyBoardMovingViewModel)
    func displayKeyboardHiding(viewModel: SignUpModels.KeyBoardWillHideViewModel)

    func displaySignInScreen(viewModel: SignUpModels.SignInViewModel)
    func displayTermsOfUseScreen(viewModel: SignUpModels.TermsOfUseViewModel)
    func displayPrivacyPolicyScreen(viewModel: SignUpModels.PrivacyPolicyViewModel)
    func displaySignUpNotification(viewModel: SignUpModels.SignUpViewModel)
}

final class SignUpViewController: UIViewController, UIScrollViewDelegate {
    // MARK: - Nested Types
    private enum Constants {
        static let offset = 16
        static let googleURL = "https://www.gmail.com"
    }

    // MARK: - Properties
    private let interactor: SignUpBusinessLogic
    private let router: SignUpRoutingLogic

    // MARK: - UI Properties
    private lazy var emailTextField: CustomTextField = {
        let textfield = CustomTextField(frame: .zero)
        textfield.style = .email
        return textfield
    }()

    private lazy var passwordTextField: CustomTextField = {
        let textfield = CustomTextField(frame: .zero)
        textfield.style = .password
        return textfield
    }()

    private lazy var confirmPasswordTextField: CustomTextField = {
        let textfield = CustomTextField(frame: .zero)
        textfield.style = .confirmPassword
        return textfield
    }()

    private lazy var usernameTextField: CustomTextField = {
        let textfield = CustomTextField(frame: .zero)
        textfield.style = .userName
        return textfield
    }()

    private lazy var textFieldsArray = [
        emailTextField,
        passwordTextField,
        confirmPasswordTextField,
        usernameTextField
    ]

    private lazy var textfieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        [
            emailTextField,
            emailError,
            passwordTextField,
            passwordError,
            confirmPasswordTextField,
            confirmPasswordError,
            usernameTextField,
            usernameError
        ].forEach { stackView.addArrangedSubview($0) }
        stackView.spacing = 16
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var emailError: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "emailError".localized(withComment: nil)
        label.textColor = Color.error
        label.adjustsFontSizeToFitWidth = true
        label.isHidden = true
        return label
    }()

    private lazy var confirmPasswordError: UILabel = {
        let label = UILabel()
        label.text = "confirmPasswordError".localized(withComment: nil)
        label.textColor = Color.error
        label.isHidden = true
        return label
    }()

    private lazy var usernameError: UILabel = {
        let label = UILabel()
        label.text = "userNameError".localized(withComment: nil)
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

    private let userimageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profilePhoto")
        return imageView
    }()

    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("signup".localized(withComment: nil), for: .normal)
        button.backgroundColor = Color.accent
        button.tintColor = .white
        button.layer.cornerRadius = 23
        return button
    }()

    private let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("signin".localized(withComment: nil), for: .normal)
        button.tintColor = .white
        return button
    }()

    private let signInLabel: UILabel = {
        let label = UILabel()
        label.text = "alreadyHaveAccount".localized(withComment: nil)
        label.textAlignment = .center
        label.textColor = Color.secondary1
        return label
    }()

    private let checkBox: UICheckBox = CheckBox(frame: .zero)
    private let contentView = UIView()
    private let termsAndPrivacyTextView = UITextView()
    private let scrollContentView = UIView()
    private let scrollView = UIScrollView()
    private lazy var notificationView = NotificationView(frame: .zero)

    // MARK: - Initialization
    init(interactor: SignUpBusinessLogic, router: SignUpRoutingLogic) {
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented in SignUpViewController")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        startSettings()
    }

    // MARK: - Private Methods
    private func startSettings() {
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
    }

    private func configureView() {
        view.isUserInteractionEnabled = true
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = Color.main

        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(textFieldEndEditing))
        view.addGestureRecognizer(recognizer)

        setupSubviews()
        setupLayout()

        configureTermsAndPrivacyTextView()
        setupButtonsTargets()
    }

    private func setupSubviews() {
        view.addSubviews([scrollView, notificationView])

        scrollView.addSubview(scrollContentView)

        scrollContentView.addSubviews(
            [
                userimageView,
                textfieldStackView,
                contentView,
                signUpButton,
                checkBox,
                termsAndPrivacyTextView
            ]
        )
        contentView.addSubviews([signInLabel, signInButton])
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
        userimageView.snp.makeConstraints { maker in
            maker.centerX.equalTo(scrollContentView.snp.centerX)
            maker.height.width.equalTo(99)
            maker.top.equalTo(scrollContentView.snp.top).offset(50)
        }
        textfieldStackView.snp.makeConstraints { maker in
            maker.top.equalTo(userimageView.snp.bottom).offset(50)
            maker.left.right.equalToSuperview().inset(Constants.offset)
        }
        checkBox.snp.makeConstraints { maker in
            maker.top.equalTo(textfieldStackView.snp.bottom).offset(Constants.offset)
            maker.left.equalTo(scrollContentView.snp.left).inset(Constants.offset)
            maker.width.height.equalTo(30)
        }
        termsAndPrivacyTextView.snp.makeConstraints { maker in
            maker.centerY.equalTo(checkBox).offset(1)
            maker.leading.equalTo(checkBox.snp.trailing)
            maker.right.equalTo(scrollContentView.snp.right).inset(Constants.offset)
            maker.height.equalTo(35)
        }
        contentView.snp.makeConstraints { maker in
            maker.height.equalTo(18)
            maker.centerX.equalTo(scrollContentView)
            maker.bottom.equalTo(scrollContentView.snp.bottom).offset(-2 * Constants.offset)
            maker.width.equalTo(260)
        }
        signInButton.snp.makeConstraints { maker in
            maker.bottom.top.trailing.equalToSuperview()
            maker.width.equalTo(60)
        }
        signInLabel.snp.makeConstraints { maker in
            maker.left.top.bottom.equalToSuperview()
            maker.trailing.equalTo(signInButton.snp.leading)
        }
        signUpButton.snp.makeConstraints { maker in
            maker.top.greaterThanOrEqualTo(termsAndPrivacyTextView.snp.bottom).offset(Constants.offset)
            maker.left.right.equalTo(scrollContentView).inset(Constants.offset)
            maker.height.equalTo(46)
            maker.bottom.equalTo(contentView.snp.top).offset(-Constants.offset)
        }
        textfieldStackView.backgroundColor = .clear
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

        let errorsArray = [emailError, passwordError, confirmPasswordError, usernameError]

        for (index, element) in textFieldsArray.enumerated()
        where element.style == textFieldWithFillingError {
            isError ? showError(position: index) : hideError(position: index)
        }
    }

    private func configureTermsAndPrivacyTextView() {
        termsAndPrivacyTextView.backgroundColor = .clear
        termsAndPrivacyTextView.isEditable = false
        termsAndPrivacyTextView.delegate = self
        termsAndPrivacyTextView.isScrollEnabled = false

        let attributedString = NSMutableAttributedString(
            string: "agreeWithTermsAndPolicy".localized(withComment: nil)
        )
        guard
            let termsOfUse = URL(string: "termsOfUseLink".localized(withComment: nil)),
            let privacyPolicy = URL(string: "privacyPolicyLink".localized(withComment: nil))
        else { return }

        attributedString.setAttributes(
            [.link: termsOfUse],
            range: NSRange(location: 15, length: 12)
        )
        attributedString.setAttributes(
            [.link: privacyPolicy],
            range: NSRange(location: 32, length: 14)
        )

        termsAndPrivacyTextView.attributedText = attributedString
        termsAndPrivacyTextView.isEditable = false
        termsAndPrivacyTextView.textColor = Color.secondary1
        termsAndPrivacyTextView.linkTextAttributes = [
            .foregroundColor: UIColor.white,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        termsAndPrivacyTextView.resizeFont()
    }

    private func setupButtonsTargets() {
        signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        signInButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        checkBox.addTarget(self, action: #selector(checkBoxChecked), for: .touchUpInside)
    }

    private func showSafari() {
        if let url = URL(string: Constants.googleURL) {
            UIApplication.shared.open(url)
        }
    }

    // MARK: - Interactor Methods
    @objc private func textFieldEndEditing(_ sender: UITapGestureRecognizer) {
        let request = SignUpModels.TextFieldEndEditingRequest()
        interactor.fetchTextFieldEndEditing(request: request)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        let request = SignUpModels.KeyBoardMovingRequest(notification: notification)
        interactor.fetchKeyboardShowing(request: request)
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        textFieldsArray.forEach {
            $0.endEditingCallBack = { [weak self] text, style in
                guard let self = self else { return }
                let request = SignUpModels.KeyBoardWillHideRequest(
                    notification: notification,
                    textFieldStyle: style,
                    text: text
                )
                self.interactor.fetchKeyboardHiding(request: request)
            }
        }
    }

    @objc private func signUp() {
        let request = SignUpModels.SignUpRequest()
        interactor.fetchSignUpNotification(request: request)
    }

    @objc private func signIn() {
        let request = SignUpModels.SignInRequest()
        interactor.fetchSignInScreen(request: request)
    }

    @objc private func checkBoxChecked() {
        let status = checkBox.isChecked
        let request = SignUpModels.CheckBoxRequest(isChecked: status)
        interactor.fetchCheckBoxStatus(request: request)
    }
}

// MARK: - SignUpDisplayLogic
extension SignUpViewController: SignUpDisplayLogic {
    func displayKeyboardHiding(viewModel: SignUpModels.KeyBoardWillHideViewModel) {
        signUpButton.isUserInteractionEnabled = true

        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset

        textFieldsArray.forEach {
            if $0.style == viewModel.textFieldStyle {
                $0.isFillingError(condition: viewModel.isError)
            }
        }
        configError(isError: viewModel.isError, textFieldWithFillingError: viewModel.textFieldStyle)
    }

    func displayKeyboardShowing(viewModel: SignUpModels.KeyBoardMovingViewModel) {
        scrollView.isScrollEnabled = true
        signUpButton.isUserInteractionEnabled = false

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

    func displayTextFieldEndEditing(viewModel: SignUpModels.TextFieldEndEditingViewModel) {
        textFieldsArray.forEach { $0.hideKeyboard() }
    }

    func displaySignInScreen(viewModel: SignUpModels.SignInViewModel) {
        router.routeToSingInScreen()
    }

    func displayTermsOfUseScreen(viewModel: SignUpModels.TermsOfUseViewModel) {
        router.routeToTermsOfUseScreen()
    }

    func displayPrivacyPolicyScreen(viewModel: SignUpModels.PrivacyPolicyViewModel) {
        router.routeToPrivacyPolicyScreen()
    }

    func displaySignUpNotification(viewModel: SignUpModels.SignUpViewModel) {
        notificationView.showNotification(type: viewModel.notificationType, message: viewModel.message) {
            if viewModel.notificationType == .success {
                self.showSafari()
                self.router.routeToSingInScreen()
            }
        }
    }
}

// MARK: - UITextView Delegate Method
extension SignUpViewController: UITextViewDelegate {
    func textView(
        _ textView: UITextView,
        shouldInteractWith URL: URL,
        in characterRange: NSRange,
        interaction: UITextItemInteraction
    ) -> Bool {
        if URL.absoluteString == "termsOfUseLink".localized(withComment: nil) {
            let request = SignUpModels.TermsOfUseRequest()
            interactor.fetchTermsOfUseScreen(request: request)
        } else if URL.absoluteString == "privacyPolicyLink".localized(withComment: nil) {
            let request = SignUpModels.PrivacyPolicyRequest()
            interactor.fetchPrivacyPolicyScreen(request: request)
        }
        return true
    }
}
