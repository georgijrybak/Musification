//
//  Safe+Array.swift
//  Musification
//
//  Created by Георгий Рыбак on 7.02.22.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
