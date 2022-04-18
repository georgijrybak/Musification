//
//  SignUpInteractor.swift
//  Musification
//
//  Created by Георгий Рыбак on 15.02.22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SignUpBusinessLogic: AnyObject {
    func fetchTextFieldEndEditing(request: SignUpModels.TextFieldEndEditingRequest)
    func fetchKeyboardHiding(request: SignUpModels.KeyBoardWillHideRequest)
    func fetchKeyboardShowing(request: SignUpModels.KeyBoardMovingRequest)
    func fetchSignInScreen(request: SignUpModels.SignInRequest)
    func fetchTermsOfUseScreen(request: SignUpModels.TermsOfUseRequest)
    func fetchPrivacyPolicyScreen(request: SignUpModels.PrivacyPolicyRequest)
    func fetchSignUpNotification(request: SignUpModels.SignUpRequest)
    func fetchCheckBoxStatus(request: SignUpModels.CheckBoxRequest)
}

final class SignUpInteractor: SignUpBusinessLogic {
    // MARK: - Properties
    private let presenter: SignUpPresentationLogic
    private let worker: SignUpWorker

    private var password = String.empty()
    private var email = String.empty()
    private var username = String.empty()
    private var confirmPassword = String.empty()
    private var isTermsAndPolicyChecked = false

    // MARK: - Initialization
    init(presenter: SignUpPresentationLogic, worker: SignUpWorker) {
        self.presenter = presenter
        self.worker = worker
    }

// MARK: - SignUpBusinessLogic
    func fetchSignInScreen(request: SignUpModels.SignInRequest) {
        let response = SignUpModels.SignInResponse()
        presenter.presentSignInScreen(response: response)
    }

    func fetchTermsOfUseScreen(request: SignUpModels.TermsOfUseRequest) {
        let response = SignUpModels.TermsOfUseResponse()
        presenter.presentTermsOfUseScreen(response: response)
    }

    func fetchPrivacyPolicyScreen(request: SignUpModels.PrivacyPolicyRequest) {
        let response = SignUpModels.PrivacyPolicyResponse()
        presenter.presentPrivacyPolicyScreen(response: response)
    }

    func fetchSignUpNotification(request: SignUpModels.SignUpRequest) {
        let fieldsStatus = checkAllFieldsStatus()
        var response = SignUpModels.SignUpResponse(
            password: String.empty(),
            email: String.empty(),
            username: String.empty(),
            responseType: .fieldsError,
            errorMessage: String.empty()
        )

        if fieldsStatus.check && fieldsStatus.text {
            worker.registerUser(username: username, password: password, email: email) { error in
                if let error = error {
                    response.errorMessage = error.localizedDescription
                    response.responseType = .registrationError
                    self.presenter.presentNotification(response: response)
                } else {
                    response.password = self.password
                    response.email = self.email
                    response.username = self.username
                    response.responseType = .success
                    self.presenter.presentNotification(response: response)
                }
            }
        } else if fieldsStatus.text && !fieldsStatus.check {
            response.responseType = .checkBoxError
            self.presenter.presentNotification(response: response)
        } else if !fieldsStatus.text || fieldsStatus.check {
            response.responseType = .fieldsError
            self.presenter.presentNotification(response: response)
        }
    }

    func fetchKeyboardHiding(request: SignUpModels.KeyBoardWillHideRequest) {
        let response = validation(text: request.text, textFieldStyle: request.textFieldStyle)
        presenter.presentKeyboardHiding(response: response)
    }

    func fetchKeyboardShowing(request: SignUpModels.KeyBoardMovingRequest) {
        let response = SignUpModels.KeyBoardMovingResponse(notification: request.notification)
        presenter.presentKeyboardShowing(response: response)
    }

    func fetchTextFieldEndEditing(request: SignUpModels.TextFieldEndEditingRequest) {
        let response = SignUpModels.TextFieldEndEditingResponse()
        presenter.presentTextFieldEndEditing(response: response)
    }

    func fetchCheckBoxStatus(request: SignUpModels.CheckBoxRequest) {
        isTermsAndPolicyChecked = request.isChecked
    }

    private func checkAllFieldsStatus() -> (text: Bool, check: Bool) {
        var complexFlag = (text: true, check: true)
        [email, password, username, confirmPassword].forEach {
            if $0.isEmpty { complexFlag.text = false }
        }
        complexFlag.check = isTermsAndPolicyChecked
        return complexFlag
    }

    private func validation(text: String, textFieldStyle: CustomTextFieldStyle) -> SignUpModels.KeyBoardWillHideResponse {
        var isError = false

        switch textFieldStyle {
        case .email:
            isError = !ValidationManager.isValidEmail(text) || text.isEmpty
            email = isError ? String.empty() : text
        case .password:
            password = text
            isError = !ValidationManager.isValidPassword(text) || text.isEmpty
            password = isError ? String.empty() : text
        case .confirmPassword:
            isError = text.isEmpty || text != password
            confirmPassword = isError ? String.empty() : text
        case .userName:
            isError = !ValidationManager.isValidUsername(text) || text.isEmpty
            username = isError ? String.empty() : text
        case .emailOrUsername:
            break
        }
        let response = SignUpModels.KeyBoardWillHideResponse(
            textFieldStyle: textFieldStyle,
            isError: isError
        )
        return response
    }
}
