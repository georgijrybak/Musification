//
//  UIButton + CheckBox.swift
//  Musification
//
//  Created by Георгий Рыбак on 16.02.22.
//

import  UIKit

protocol UICheckBox: UIButton {
    var isChecked: Bool { get }
    func changeCheck()
}

class CheckBox: UIButton, UICheckBox {
    // Images
    private let checkedImage = UIImage(named: "checkbox")
    private let uncheckedImage = UIImage(named: "unCheckbox")

    // Bool property
    var isChecked = false

    override init(frame: CGRect) {
        super.init(frame: frame)

        setImage(uncheckedImage, for: .normal)
        self.addTarget(
            self,
            action: #selector(buttonClicked(sender:)),
            for: UIControl.Event.touchUpInside
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func changeCheck() {
        if isChecked {
            self.setImage(uncheckedImage, for: .normal)
            isChecked = false
        } else {
            self.setImage(checkedImage, for: .normal)
            isChecked = true
        }
    }

    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            changeCheck()
        }
    }
}
