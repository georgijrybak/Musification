//
//  SignInInteractor.swift
//  Musification
//
//  Created by Георгий Рыбак on 11.02.22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SignInBusinessLogic: AnyObject {
    func fetchTextFieldEndEditing(request: SignInModels.TextFieldEndEditingRequest)
    func fetchKeyboardHiding(request: SignInModels.KeyBoardWillHideRequest)
    func fetchKeyboardShowing(request: SignInModels.KeyBoardMovingRequest)
    func fetchSignUpScreen(request: SignInModels.SignUpRequest)
    func fetchResetPasswordScreen(request: SignInModels.ResetPasswordRequest)
    func fetchSignInNotification(request: SignInModels.SignInRequest)
}

final class SignInInteractor: SignInBusinessLogic {
   // MARK: - Properties
    private let presenter: SignInPresentationLogic
    private let worker: SignInWorker

    private var password = String.empty()
    private var email = String.empty()
    private var username = String.empty()

    // MARK: - Initialization
    init(presenter: SignInPresentationLogic, worker: SignInWorker) {
        self.presenter = presenter
        self.worker = worker
    }

    func fetchKeyboardHiding(request: SignInModels.KeyBoardWillHideRequest) {
        let response = validation(text: request.text, textFieldStyle: request.textFieldStyle)
        presenter.presentKeyboardHiding(response: response)
    }

    func fetchKeyboardShowing(request: SignInModels.KeyBoardMovingRequest) {
        let response = SignInModels.KeyBoardMovingResponse(notification: request.notification)
        presenter.presentKeyboardShowing(response: response)
    }

    func fetchTextFieldEndEditing(request: SignInModels.TextFieldEndEditingRequest) {
        let response = SignInModels.TextFieldEndEditingResponse()
        presenter.presentTextFieldEndEditing(response: response)
    }

    func fetchSignUpScreen(request: SignInModels.SignUpRequest) {
        let response = SignInModels.SignUpResponse()
        presenter.presentSignUpScreen(response: response)
    }

    func fetchResetPasswordScreen(request: SignInModels.ResetPasswordRequest) {
        let response = SignInModels.ResetPasswordResponse()
        presenter.presentResetPasswordScreen(response: response)
    }

    func fetchSignInNotification(request: SignInModels.SignInRequest) {
        let ationIfAllGood = {
            self.email.isEmpty ?
                self.worker.signIn(emailOrUsername: self.username, password: self.password) { error in
                    if let error = error {
                        let response = SignInModels.SignInResponse(
                            allRightCheck: false,
                            errorMessage: error.localizedDescription
                        )
                        self.presenter.presentNotification(response: response)
                    } else {
                        let response = SignInModels.SignInResponse(allRightCheck: true, errorMessage: String.empty())
                        self.presenter.presentNotification(response: response)
                    }
                } :
                self.worker.signIn(emailOrUsername: self.email, password: self.password) { error in
                    if let error = error {
                        let response = SignInModels.SignInResponse(
                            allRightCheck: false,
                            errorMessage: error.localizedDescription
                        )
                        self.presenter.presentNotification(response: response)
                    } else {
                        let response = SignInModels.SignInResponse(allRightCheck: true, errorMessage: String.empty())
                        self.presenter.presentNotification(response: response)
                    }
                }
        }

        let ationIfSomethingBad = {
            let response = SignInModels.SignInResponse(
                allRightCheck: false,
                errorMessage: "fieldsError".localized(withComment: nil)
            )
            self.presenter.presentNotification(response: response)
        }
        checkAllFieldsStatus() ? ationIfAllGood() : ationIfSomethingBad()
    }

    private func checkAllFieldsStatus() -> Bool {
        return email.isEmpty || username.isEmpty && password.isEmpty ? false : true
    }

    private func validation(text: String, textFieldStyle: CustomTextFieldStyle) -> SignInModels.KeyBoardWillHideResponse {
        var isError = false

        switch textFieldStyle {
        case .emailOrUsername:
            if text.contains("@") {
                isError =
                    !ValidationManager.isValidEmail(text)
                    || text.isEmpty
                    && !ValidationManager.isValidUsername(text)
            } else {
                isError = !ValidationManager.isValidUsername(text) || text.isEmpty
            }
            email = isError ? String.empty() : text
        case .password:
            password = text
            isError = !ValidationManager.isValidPassword(text) || text.isEmpty
            password = isError ? String.empty() : text

        default:
            break
        }

        let response = SignInModels.KeyBoardWillHideResponse(
            textFieldStyle: textFieldStyle,
            isError: isError
        )
        return response
    }
}
