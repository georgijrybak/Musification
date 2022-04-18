//
//  SignInAssembly.swift
//  Musification
//
//  Created by Георгий Рыбак on 11.02.22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum SignInAssembly {
    static func assembly() -> UIViewController {
        let presenter = SignInPresenter()
        let router = SignInRouter()
        let worker = SignInWorker()
        let interactor = SignInInteractor(presenter: presenter, worker: worker)
        let viewController = SignInViewController(interactor: interactor, router: router)

        router.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
