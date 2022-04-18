//
//  DiscoverScreenAssembly.swift
//  Musification
//
//  Created by Георгий Рыбак on 25.02.22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum DiscoverScreenAssembly {
    static func assembly() -> UIViewController {
        let presenter = DiscoverScreenPresenter()
        let router = DiscoverScreenRouter()
        let worker = DiscoverScreenWorker()
        let interactor = DiscoverScreenInteractor(presenter: presenter, worker: worker)
        let viewController = DiscoverScreenViewController(interactor: interactor, router: router)

        router.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
