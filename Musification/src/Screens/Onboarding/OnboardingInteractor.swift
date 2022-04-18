//
//  OnboardingInteractor.swift
//  Musification
//
//  Created by Георгий Рыбак on 9.02.22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

protocol OnboardingBusinessLogic: AnyObject {
    func setUnboardingPassed()
    func fetchNextButtonCondition()
    func fetchSkipButtonCondition()
}

final class OnboardingInteractor: OnboardingBusinessLogic {
    // MARK: - Properties
    private let presenter: OnboardingPresentationLogic
    private let settings: Settings

    // MARK: - Initialization
    init(presenter: OnboardingPresentationLogic, settings: Settings) {
        self.presenter = presenter
        self.settings = settings
    }

    func fetchSkipButtonCondition() {
        presenter.presentButtonAction()
    }

    func fetchNextButtonCondition() {
        presenter.presentТextButtonAction()
    }

    func setUnboardingPassed() {
        settings.onboardingComplited = true
    }
}
