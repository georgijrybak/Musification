//
//  SplashScreenAssembly.swift
//  Musification
//
//  Created by Георгий Рыбак on 10.02.22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum SplashScreenAssembly {
    static func assembly() -> UIViewController {
        let presenter = SplashScreenPresenter()
        let router = SplashScreenRouter()
        let settings = Settings.shared
        let interactor = SplashScreenInteractor(presenter: presenter, settings: settings)
        let viewController = SplashScreenViewController(interactor: interactor, router: router)

        router.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
