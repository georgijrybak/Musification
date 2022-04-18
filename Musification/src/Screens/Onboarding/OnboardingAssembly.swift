//
//  OnboardingAssembly.swift
//  Musification
//
//  Created by Георгий Рыбак on 9.02.22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum OnboardingAssembly {
    static func assembly() -> UIViewController {
        let presenter = OnboardingPresenter()
        let router = OnboardingRouter()
        let settings = Settings.shared
        let interactor = OnboardingInteractor(presenter: presenter, settings: settings)
        let viewController = OnboardingViewController(interactor: interactor, router: router)

        router.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
