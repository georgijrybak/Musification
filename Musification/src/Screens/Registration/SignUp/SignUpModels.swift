//
//  SignUpModels.swift
//  Musification
//
//  Created by Георгий Рыбак on 15.02.22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
import Foundation

enum RegistrationResponseType {
    case fieldsError
    case checkBoxError
    case registrationError
    case success
}

enum SignUpModels {
    struct KeyBoardMovingRequest { var notification: NSNotification }

    struct KeyBoardMovingResponse { var notification: NSNotification }

    struct KeyBoardMovingViewModel { var notification: NSNotification }

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

    struct TextFieldEndEditingRequest {}

    struct TextFieldEndEditingResponse {}

    struct TextFieldEndEditingViewModel {}

    struct SignInRequest {}

    struct SignInResponse {}

    struct SignInViewModel {}

    struct SignUpRequest {}

    struct SignUpResponse {
        var password: String
        var email: String
        var username: String
        var responseType: RegistrationResponseType
        var errorMessage: String
    }

    struct SignUpViewModel {
        var notificationType: NotificationType
        var message: String
    }

    struct TermsOfUseRequest {}

    struct TermsOfUseResponse {}

    struct TermsOfUseViewModel {}

    struct PrivacyPolicyRequest {}

    struct PrivacyPolicyResponse {}

    struct PrivacyPolicyViewModel {}

    struct CheckBoxRequest {
        var isChecked: Bool
    }
}
