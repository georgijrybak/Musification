//
//  ResetPasswordModels.swift
//  Musification
//
//  Created by Георгий Рыбак on 21.02.22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

enum ResetPasswordResponseType {
    case error
    case success
}

enum ResetPasswordModels {
    struct TextEndEditingRequest {}
    struct TextEndEditingResponse {}
    struct TextEndEditingViewModel {}

    struct KeyBoardWillHideRequest {
        var emailOrUsername: String
    }
    struct KeyBoardWillHideResponse {}
    struct KeyBoardWillHideViewModel {}

    struct ResetPasswordRequest {}
    struct ResetPasswordResponse {
        var responseType: ResetPasswordResponseType
        var errorMessage: String
    }
    struct ResetPasswordViewModel {
        var notificationType: NotificationType
        var message: String
    }
}
