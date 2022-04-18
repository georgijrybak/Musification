//
//  OnboardingRouter.swift
//  Musification
//
//  Created by Георгий Рыбак on 9.02.22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

protocol OnboardingRoutingLogic: AnyObject {
    func routeToLogin()
    func back()
}

final class OnboardingRouter: OnboardingRoutingLogic {
    func routeToLogin() {
        let nextVC = SignInAssembly.assembly()
        viewController?.navigationController?.pushViewController(nextVC, animated: false)
    }

    // MARK: - Properties
    weak var viewController: OnboardingViewController?
    func back() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
