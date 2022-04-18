//
//  SignUpAssembly.swift
//  Musification
//
//  Created by Георгий Рыбак on 15.02.22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum SignUpAssembly {
    static func assembly() -> UIViewController {
        let presenter = SignUpPresenter()
        let router = SignUpRouter()
        let worker = SignUpWorker()
        let interactor = SignUpInteractor(presenter: presenter, worker: worker)
        let viewController = SignUpViewController(interactor: interactor, router: router)

        router.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
