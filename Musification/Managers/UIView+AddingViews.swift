//
//  UIView+AddingViews.swift
//  Musification
//
//  Created by Георгий Рыбак on 7.02.22.
//

import UIKit

extension UIView {
    func addSubviews(_ array: [UIView]) {
        array.forEach {
            addSubview($0)
        }
    }
}
