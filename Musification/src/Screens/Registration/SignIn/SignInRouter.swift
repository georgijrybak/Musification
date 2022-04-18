//
//  SignInRouter.swift
//  Musification
//
//  Created by Георгий Рыбак on 11.02.22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

protocol SignInRoutingLogic: AnyObject {
    func routeToSingUpScreen()
    func routeToResetPasswordScreen()
    func routeToMainScreen()
}

final class SignInRouter: SignInRoutingLogic {
    // MARK: - Properties
    weak var viewController: SignInViewController?

    func routeToSingUpScreen() {
        let nextVC = SignUpAssembly.assembly()
        viewController?.navigationController?.pushViewController(nextVC, animated: true)
    }

    func routeToResetPasswordScreen() {
        let nextVC = ResetPasswordAssembly.assembly()
        nextVC.title = "Reset Password"
        viewController?.navigationController?.pushViewController(nextVC, animated: true)
    }

    func routeToMainScreen() {
        let nextVC = MainTabBarController()
        viewController?.navigationController?.pushViewController(nextVC, animated: true)
    }
}
