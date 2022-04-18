//
//  UITextView + AutoSizeFont.swift
//  Musification
//
//  Created by Георгий Рыбак on 17.02.22.
//

import UIKit
extension UITextView {
    func resizeFont() {
        self.layoutIfNeeded()

        if self.text.isEmpty || self.bounds.size.equalTo(CGSize.zero) { return }

        let textViewSize = self.frame.size
        let fixedWidth = textViewSize.width
        let expectSize = self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT)))

        var expectFont = self.font
        if expectSize.height > textViewSize.height {
            while self.sizeThatFits(
                    CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))
            ).height > textViewSize.height {
                guard let textViewFont = self.font else { return }
                expectFont = textViewFont.withSize(textViewFont.pointSize - 1)
                self.font = expectFont
            }
        } else {
            while self.sizeThatFits(
                    CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))
            ).height < textViewSize.height {
                guard let textViewFont = self.font else { return }
                expectFont = self.font
                self.font = textViewFont.withSize(textViewFont.pointSize + 1)
            }
            self.font = expectFont
        }
    }
}
