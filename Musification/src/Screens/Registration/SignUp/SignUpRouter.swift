//
//  SignUpRouter.swift
//  Musification
//
//  Created by Георгий Рыбак on 15.02.22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

protocol SignUpRoutingLogic: AnyObject {
    func routeToTermsOfUseScreen()
    func routeToPrivacyPolicyScreen()
    func routeToSingInScreen()
    func routeToMainScreen()
}

final class SignUpRouter: SignUpRoutingLogic {
    // MARK: - Properties
    weak var viewController: SignUpViewController?

    func routeToTermsOfUseScreen() {
        let nextVC = TermsOfUseViewController()
        nextVC.title = "Terms of Use"
        viewController?.navigationController?.pushViewController(nextVC, animated: true)
    }

    func routeToPrivacyPolicyScreen() {
        let nextVC = PrivacyPolicyViewController()
        nextVC.title = "Privacy Policy"
        viewController?.navigationController?.pushViewController(nextVC, animated: true)
    }

    func routeToSingInScreen() {
        viewController?.navigationController?.popViewController(animated: true)
    }

    func routeToMainScreen() {
        let nextVC = MainTabBarController()
        nextVC.title = "Main"
        viewController?.navigationController?.pushViewController(nextVC, animated: true)
    }
}
