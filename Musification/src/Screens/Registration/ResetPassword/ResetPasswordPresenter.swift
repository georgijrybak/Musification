//
//  ResetPasswordPresenter.swift
//  Musification
//
//  Created by Георгий Рыбак on 21.02.22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

protocol ResetPasswordPresentationLogic: AnyObject {
    func presentTextFieldEndEditing(response: ResetPasswordModels.TextEndEditingResponse)
    func presentKeyboardHiding(response: ResetPasswordModels.KeyBoardWillHideResponse)
    func presentNotification(response: ResetPasswordModels.ResetPasswordResponse)
}

final class ResetPasswordPresenter: ResetPasswordPresentationLogic {
    // MARK: - Properties
    weak var viewController: ResetPasswordDisplayLogic?

    // MARK: - ResetPasswordPresentationLogic
    func presentTextFieldEndEditing(response: ResetPasswordModels.TextEndEditingResponse) {
        let viewModel = ResetPasswordModels.TextEndEditingViewModel()
        viewController?.displayTextFieldEndEditing(viewModel: viewModel)
    }

    func presentKeyboardHiding(response: ResetPasswordModels.KeyBoardWillHideResponse) {
        let viewModel = ResetPasswordModels.KeyBoardWillHideViewModel()
        viewController?.displayKeyboardHiding(viewModel: viewModel)
    }

    func presentNotification(response: ResetPasswordModels.ResetPasswordResponse) {
        var viewModel = ResetPasswordModels.ResetPasswordViewModel(notificationType: .error, message: "")

        switch response.responseType {
        case .success:
            viewModel.message = "sucessResetPasswordMessage".localized(withComment: nil)
            viewModel.notificationType = .success
        case .error:
            viewModel.notificationType = .error
            viewModel.message = response.errorMessage
        }
        viewController?.displaySignUpNotification(viewModel: viewModel)
    }
}
