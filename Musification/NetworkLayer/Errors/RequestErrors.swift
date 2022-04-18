//
//  RequestErrors.swift
//  Musification
//
//  Created by Георгий Рыбак on 9.02.22.
//

import Foundation

enum ErrorResponse: String, Error {
    case invalidEndpoint = "check login/password)"
    case serverError = "server side error"
    case invalidURLRequest = "URLRequest is invalid"
}
