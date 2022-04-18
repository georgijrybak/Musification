//
//  OnboardingPresenter.swift
//  Musification
//
//  Created by Георгий Рыбак on 9.02.22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

protocol OnboardingPresentationLogic: AnyObject {
    func presentТextButtonAction()
    func presentButtonAction()
}

final class OnboardingPresenter: OnboardingPresentationLogic {
    // MARK: - Properties
    weak var viewController: OnboardingDisplayLogic?

    func presentButtonAction() {
        viewController?.displayLoginScreen()
    }

    func presentТextButtonAction() {
        viewController?.displayScrolling()
    }
}
