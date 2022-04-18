//
//  SearchViewController.swift
//  Musification
//
//  Created by Георгий Рыбак on 21.02.22.
//

import UIKit
import Firebase

class DiscoverViewController: UIViewController {
    let button = UIButton(type: .system)
    let notification = NotificationView(frame: .zero)
    let user = Auth.auth().currentUser

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.title = "discover".localized(withComment: nil)
        navigationController?.navigationBar.tintColor = .white

        view.backgroundColor = Color.main
        navigationController?.isNavigationBarHidden = false

        setupLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let isUserEmailVerified = user?.isEmailVerified {
            if !isUserEmailVerified {
                notification.showNotification(
                    type: .error,
                    message: "emilVerificationError".localized(withComment: nil),
                    completion: nil
                )
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.isNavigationBarHidden = true
    }

    private func setupLayout() {
        view.addSubview(button)
        view.addSubview(notification)

        notification.snp.makeConstraints { maker in
            maker.edges.equalTo(view.safeAreaLayoutGuide)
        }
        button.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.height.width.equalTo(100)
        }
        button.setTitle("signOut".localized(withComment: nil), for: .normal)
        button.addTarget(self, action: #selector(signOut), for: .touchUpInside)
    }

    @objc private func signOut() {
        try? Auth.auth().signOut()
        let signInVC = SignInAssembly.assembly()
        UIApplication.shared.windows.first?.rootViewController = signInVC
    }
}
