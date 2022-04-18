//
//  TermsOfUseViewController.swift
//  Musification
//
//  Created by Георгий Рыбак on 16.02.22.
//

import UIKit
import SnapKit

class TermsOfUseViewController: UIViewController {
    let termsOfUseTextView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupStyles()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.isNavigationBarHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.isNavigationBarHidden = true
    }

    private func setupStyles() {
        view.backgroundColor = .white

        termsOfUseTextView.backgroundColor = .clear
        termsOfUseTextView.textColor = .black
        termsOfUseTextView.text = "termsOfUse".localized(withComment: nil)
        termsOfUseTextView.isEditable = false
        termsOfUseTextView.scrollRangeToVisible(NSRange(location: 0, length: 0))
    }

    private func setupLayout() {
        view.addSubview(termsOfUseTextView)

        termsOfUseTextView.snp.makeConstraints { maker in
            maker.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
