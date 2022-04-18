//
//  SplashScreenPresenter.swift
//  Musification
//
//  Created by Георгий Рыбак on 10.02.22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

protocol SplashScreenPresentationLogic: AnyObject {
    func presentOnboardingScreen()
    func presentMainScreen()
    func presentSignInScreen()
}

final class SplashScreenPresenter: SplashScreenPresentationLogic {
    // MARK: - Properties
    weak var viewController: SplashScreenDisplayLogic?

    func presentOnboardingScreen() {
        viewController?.displayOnboardingScreen()
    }

    func presentMainScreen() {
        viewController?.displayMainScreen()
    }

    func presentSignInScreen() {
        viewController?.displaySignInScreen()
    }
}
