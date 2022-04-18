//
//  String+Localized.swift
//  Musification
//
//  Created by Георгий Рыбак on 7.02.22.
//

import UIKit

extension String {
    static func empty() -> String {
        return ""
    }

    func localized(withComment comment: String? = nil) -> String {
        return NSLocalizedString(self, comment: comment ?? "")
    }
}
