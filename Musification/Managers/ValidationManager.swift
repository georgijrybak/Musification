//
//  ValidationManager.swift
//  Musification
//
//  Created by Георгий Рыбак on 18.02.22.
//

import Foundation

enum ValidationManager {
    static func isValidEmail(_ email: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,320}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }

    static func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{6,50}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }

    static func isValidUsername(_ name: String) -> Bool {
        let nameRegex = "[A-Za-z]+[A-Za-z0-9_-]{2,15}"
        return NSPredicate(format: "SELF MATCHES %@", nameRegex).evaluate(with: name)
    }
}
