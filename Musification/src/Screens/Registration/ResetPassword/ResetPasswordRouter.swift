//
//  ResetPasswordRouter.swift
//  Musification
//
//  Created by Георгий Рыбак on 21.02.22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

protocol ResetPasswordRoutingLogic: AnyObject {
    func back()
}

final class ResetPasswordRouter: ResetPasswordRoutingLogic {
    // MARK: - Properties
    weak var viewController: ResetPasswordViewController?

    func back() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
