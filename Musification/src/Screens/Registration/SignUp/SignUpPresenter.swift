//
//  SignUpPresenter.swift
//  Musification
//
//  Created by Георгий Рыбак on 15.02.22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SignUpPresentationLogic: AnyObject {
    func presentTextFieldEndEditing(response: SignUpModels.TextFieldEndEditingResponse)
    func presentKeyboardHiding(response: SignUpModels.KeyBoardWillHideResponse)
    func presentKeyboardShowing(response: SignUpModels.KeyBoardMovingResponse)
    func presentSignInScreen(response: SignUpModels.SignInResponse)
    func presentTermsOfUseScreen(response: SignUpModels.TermsOfUseResponse)
    func presentPrivacyPolicyScreen(response: SignUpModels.PrivacyPolicyResponse)
    func presentNotification(response: SignUpModels.SignUpResponse)
}

final class SignUpPresenter: SignUpPresentationLogic {
// MARK: - Properties
    weak var viewController: SignUpDisplayLogic?

    func presentSignInScreen(response: SignUpModels.SignInResponse) {
        let viewModel = SignUpModels.SignInViewModel()
        viewController?.displaySignInScreen(viewModel: viewModel)
    }

    func presentTermsOfUseScreen(response: SignUpModels.TermsOfUseResponse) {
        let viewModel = SignUpModels.TermsOfUseViewModel()
        viewController?.displayTermsOfUseScreen(viewModel: viewModel)
    }

    func presentPrivacyPolicyScreen(response: SignUpModels.PrivacyPolicyResponse) {
        let viewModel = SignUpModels.PrivacyPolicyViewModel()
        viewController?.displayPrivacyPolicyScreen(viewModel: viewModel)
    }

    func presentNotification(response: SignUpModels.SignUpResponse) {
        var viewModel = SignUpModels.SignUpViewModel(notificationType: .error, message: "")

        switch response.responseType {
        case .success:
            let localizedString = NSLocalizedString("successMessage", comment: "nil")
            viewModel.notificationType = .success
            viewModel.message = String(format: localizedString, response.username, response.email)
        case .fieldsError:
            viewModel.notificationType = .error
            viewModel.message = "fieldsError".localized(withComment: nil)
        case .checkBoxError:
            viewModel.notificationType = .error
            viewModel.message = "termsError".localized(withComment: nil)
        case.registrationError:
            viewModel.notificationType = .error
            viewModel.message = response.errorMessage
        }
        viewController?.displaySignUpNotification(viewModel: viewModel)
    }

    func presentKeyboardShowing(response: SignUpModels.KeyBoardMovingResponse) {
        let viewModel = SignUpModels.KeyBoardMovingViewModel(notification: response.notification)
        viewController?.displayKeyboardShowing(viewModel: viewModel)
    }

    func presentKeyboardHiding(response: SignUpModels.KeyBoardWillHideResponse) {
        let viewModel = SignUpModels.KeyBoardWillHideViewModel(
            textFieldStyle: response.textFieldStyle,
            isError: response.isError
        )
        viewController?.displayKeyboardHiding(viewModel: viewModel)
    }

    func presentTextFieldEndEditing(response: SignUpModels.TextFieldEndEditingResponse) {
        let viewModel = SignUpModels.TextFieldEndEditingViewModel()
        viewController?.displayTextFieldEndEditing(viewModel: viewModel)
    }
}
