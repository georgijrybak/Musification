//
//  Settings.swift
//  Musification
//
//  Created by Георгий Рыбак on 10.02.22.
//

import UIKit

enum Color {
    static let accent = UIColor(named: "Accent")
    static let error = UIColor(named: "Error")
    static let main = UIColor(named: "Main")
    static let secondary1 = UIColor(named: "Secondary1")
    static let secondary2 = UIColor(named: "Secondary2")
}

class Settings {
    enum UserDefaultsKeys: String {
        case onboardingComplited
    }

    static var shared = Settings()

    var onboardingComplited: Bool {
        get {
            UserDefaults.standard.bool(
                forKey: UserDefaultsKeys.onboardingComplited.rawValue
            )
        }
        set {
            UserDefaults.standard.set(
                newValue,
                forKey: UserDefaultsKeys.onboardingComplited.rawValue
            )
        }
    }
}
