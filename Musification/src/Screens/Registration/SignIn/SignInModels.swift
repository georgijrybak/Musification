//
//  SignInModels.swift
//  Musification
//
//  Created by Георгий Рыбак on 11.02.22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
import Foundation
enum SignInModels {
    struct KeyBoardMovingRequest { var notification: NSNotification }

    struct KeyBoardMovingResponse { var notification: NSNotification }

    struct KeyBoardMovingViewModel { var notification: NSNotification }

    struct TextFieldEndEditingRequest {}

    struct TextFieldEndEditingResponse {}

    struct TextFieldEndEditingViewModel {}

    struct ResetPasswordRequest {}

    struct ResetPasswordResponse {}

    struct ResetPasswordViewModel {}

    struct SignUpRequest {}

    struct SignUpResponse {}

    struct SignUpViewModel {}

    struct SignInRequest {}

    struct SignInResponse {
        var allRightCheck: Bool
        var errorMessage: String
    }

    struct SignInViewModel {
        var notificationType: NotificationType
        var message: String
        var isSomethingBad: Bool
    }

    struct RegistrationRequest {
        var password: String
        var email: String
        var username: String
    }

    struct KeyBoardWillHideRequest {
        var notification: NSNotification
        var textFieldStyle: CustomTextFieldStyle
        var text: String
    }

    struct KeyBoardWillHideResponse {
        var textFieldStyle: CustomTextFieldStyle
        var isError: Bool
    }

    struct KeyBoardWillHideViewModel {
        var textFieldStyle: CustomTextFieldStyle
        var isError: Bool
    }
}
