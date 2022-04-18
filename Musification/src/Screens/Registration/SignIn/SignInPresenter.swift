//
//  SignInPresenter.swift
//  Musification
//
//  Created by Георгий Рыбак on 11.02.22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SignInPresentationLogic: AnyObject {
    func presentTextFieldEndEditing(response: SignInModels.TextFieldEndEditingResponse)
    func presentKeyboardHiding(response: SignInModels.KeyBoardWillHideResponse)
    func presentKeyboardShowing(response: SignInModels.KeyBoardMovingResponse)
    func presentSignUpScreen(response: SignInModels.SignUpResponse)
    func presentResetPasswordScreen(response: SignInModels.ResetPasswordResponse)
    func presentNotification(response: SignInModels.SignInResponse)}

final class SignInPresenter: SignInPresentationLogic {
    // MARK: - Properties
    weak var viewController: SignInDisplayLogic?

    func presentKeyboardShowing(response: SignInModels.KeyBoardMovingResponse) {
        let viewModel = SignInModels.KeyBoardMovingViewModel(notification: response.notification)
        viewController?.displayKeyboardShowing(viewModel: viewModel)
    }

    func presentKeyboardHiding(response: SignInModels.KeyBoardWillHideResponse) {
        let viewModel = SignInModels.KeyBoardWillHideViewModel(
            textFieldStyle: response.textFieldStyle,
            isError: response.isError
        )
        viewController?.displayKeyboardHiding(viewModel: viewModel)
    }

    func presentTextFieldEndEditing(response: SignInModels.TextFieldEndEditingResponse) {
        let viewModel = SignInModels.TextFieldEndEditingViewModel()
        viewController?.displayTextFieldEndEditing(viewModel: viewModel)
    }

    func presentSignUpScreen(response: SignInModels.SignUpResponse) {
        let viewModel = SignInModels.SignUpViewModel()
        viewController?.displaySignUpScreen(viewModel: viewModel)
    }

    func presentResetPasswordScreen(response: SignInModels.ResetPasswordResponse) {
        let viewModel = SignInModels.ResetPasswordViewModel()
        viewController?.displayResetPasswordScreen(viewModel: viewModel)
    }

    func presentNotification(response: SignInModels.SignInResponse) {
        var viewModel = SignInModels.SignInViewModel(
            notificationType: .success,
            message: String.empty(),
            isSomethingBad: false
        )

        switch response.allRightCheck {
        case true:
            viewController?.displaySignInNotification(viewModel: viewModel)
        case false:
            viewModel.isSomethingBad = true
            viewModel.message = response.errorMessage
            viewModel.notificationType = .error
            viewController?.displaySignInNotification(viewModel: viewModel)
        }
    }
}
