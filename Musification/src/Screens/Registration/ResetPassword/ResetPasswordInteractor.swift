//
//  ResetPasswordInteractor.swift
//  Musification
//
//  Created by Георгий Рыбак on 21.02.22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

protocol ResetPasswordBusinessLogic: AnyObject {
    func fetchTextFieldEndEditing(request: ResetPasswordModels.TextEndEditingRequest)
    func fetchKeyboardHiding(request: ResetPasswordModels.KeyBoardWillHideRequest)
    func fetchSignUpNotification(request: ResetPasswordModels.ResetPasswordRequest)
}

final class ResetPasswordInteractor: ResetPasswordBusinessLogic {
    // MARK: - Properties
    private let presenter: ResetPasswordPresentationLogic
    private let worker: ResetPasswordWorker

    private var emailOrUsername = String.empty()

    // MARK: - Initialization
    init(presenter: ResetPasswordPresentationLogic, worker: ResetPasswordWorker) {
        self.presenter = presenter
        self.worker = worker
    }

    // MARK: - ResetPasswordBusinessLogic
    func fetchTextFieldEndEditing(request: ResetPasswordModels.TextEndEditingRequest) {
        let response = ResetPasswordModels.TextEndEditingResponse()
        presenter.presentTextFieldEndEditing(response: response)
    }

    func fetchKeyboardHiding(request: ResetPasswordModels.KeyBoardWillHideRequest) {
        emailOrUsername = request.emailOrUsername
        let response = ResetPasswordModels.KeyBoardWillHideResponse()
        presenter.presentKeyboardHiding(response: response)
    }

    func fetchSignUpNotification(request: ResetPasswordModels.ResetPasswordRequest) {
        worker.resetPassword(email: emailOrUsername) { error in
            if let error = error {
                let response = ResetPasswordModels.ResetPasswordResponse(
                    responseType: .error,
                    errorMessage: error.localizedDescription
                )
                self.presenter.presentNotification(response: response)
            } else {
                let response = ResetPasswordModels.ResetPasswordResponse(
                    responseType: .success,
                    errorMessage: String.empty()
                )
                self.presenter.presentNotification(response: response)
            }
        }
    }
}
