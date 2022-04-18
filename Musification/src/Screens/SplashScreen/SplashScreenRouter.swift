//
//  SplashScreenRouter.swift
//  Musification
//
//  Created by Георгий Рыбак on 10.02.22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

protocol SplashScreenRoutingLogic: AnyObject {
    func back()
    func routeToOnboardingScreen()
    func routeToMainScreen()
    func routeToSignInScreen()
}

final class SplashScreenRouter: SplashScreenRoutingLogic {
    // MARK: - Properties
    weak var viewController: SplashScreenViewController?

    func back() {
        viewController?.navigationController?.popViewController(animated: true)
    }

    func routeToOnboardingScreen() {
        let nextVC = OnboardingAssembly.assembly()
        viewController?.navigationController?.pushViewController(nextVC, animated: false)
    }

    func routeToMainScreen() {
        let nextVC = MainTabBarController()
        viewController?.navigationController?.pushViewController(nextVC, animated: false)
    }

    func routeToSignInScreen() {
        let nextVC = SignInAssembly.assembly()
        viewController?.navigationController?.pushViewController(nextVC, animated: false)
    }
}
