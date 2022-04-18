//
//  PrivacyPolicyViewController.swift
//  Musification
//
//  Created by Георгий Рыбак on 16.02.22.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {
    let privacyPolicyextView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = false
        view.backgroundColor = .white

        view.addSubview(privacyPolicyextView)

        privacyPolicyextView.snp.makeConstraints { maker in
            maker.edges.equalTo(view.safeAreaLayoutGuide)
        }
        privacyPolicyextView.backgroundColor = .clear
        privacyPolicyextView.textColor = .black
        privacyPolicyextView.text = "privacyPolicy".localized(withComment: nil)
        privacyPolicyextView.isEditable = false
        privacyPolicyextView.scrollRangeToVisible(NSRange(location: 0, length: 0))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.isNavigationBarHidden = true
    }
}
