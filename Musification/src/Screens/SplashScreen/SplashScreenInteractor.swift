//
//  SplashScreenInteractor.swift
//  Musification
//
//  Created by Георгий Рыбак on 10.02.22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
import Firebase

protocol SplashScreenBusinessLogic: AnyObject {
    func fetchFirstScreen()
}

final class SplashScreenInteractor: SplashScreenBusinessLogic {
    // MARK: - Properties
    private let presenter: SplashScreenPresentationLogic
    private let settings: Settings

    // MARK: - Initialization
    init(presenter: SplashScreenPresentationLogic, settings: Settings) {
        self.presenter = presenter
        self.settings = settings
    }

    func fetchFirstScreen() {
        let onboardingStatus = Settings.shared.onboardingComplited
        let user = Auth.auth().currentUser

        onboardingStatus ?
            user != nil ? presenter.presentMainScreen() : presenter.presentSignInScreen() :
            presenter.presentOnboardingScreen()
    }
}
