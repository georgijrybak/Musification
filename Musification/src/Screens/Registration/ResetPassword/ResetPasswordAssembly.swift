//
//  ResetPasswordAssembly.swift
//  Musification
//
//  Created by Георгий Рыбак on 21.02.22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum ResetPasswordAssembly {
    static func assembly() -> UIViewController {
        let presenter = ResetPasswordPresenter()
        let router = ResetPasswordRouter()
        let worker = ResetPasswordWorker()
        let interactor = ResetPasswordInteractor(presenter: presenter, worker: worker)
        let viewController = ResetPasswordViewController(interactor: interactor, router: router)

        router.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
